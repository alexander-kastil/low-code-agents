#Requires -Modules @{ ModuleName="Microsoft.Graph.Users"; ModuleVersion="2.0" }
#Requires -Modules @{ ModuleName="Microsoft.PowerApps.Administration.PowerShell"; ModuleVersion="2.0" }

param(
    [string]$TenantDomain = "cloud-agents.org",
    [string]$UsernamePattern = "copilot-studio",
    [int]$UserCount = 4,
    [string]$EnvironmentDisplayName = $null,
    [ValidateSet("System Administrator", "System Customizer")]
    [string]$RoleToAssign = "System Customizer"
)

function Get-InstanceUrl {
    param([object]$Env)
    $paths = @(
        "Internal.properties.linkedEnvironmentMetadata.instanceUrl",
        "Internal.properties.instanceUrl",
        "Properties.linkedEnvironmentMetadata.instanceUrl",
        "Properties.instanceUrl"
    )
    foreach ($path in $paths) {
        $cur = $Env; $ok = $true
        foreach ($seg in ($path -split '\.')) {
            if ($null -eq $cur) { $ok = $false; break }
            $p = $cur.PSObject.Properties[$seg]
            if ($p) { $cur = $p.Value; continue }
            $ok = $false; break
        }
        if ($ok -and -not [string]::IsNullOrWhiteSpace([string]$cur)) {
            return ([string]$cur).TrimEnd('/')
        }
    }
    return $null
}

function Invoke-DvRequest {
    param([string]$InstanceUrl, [string]$Token, [string]$Path, [string]$Method = "Get", [hashtable]$Body = $null)
    $uri = "$($InstanceUrl.TrimEnd('/'))/api/data/v9.2/$($Path.TrimStart('/'))"
    $h = @{ Authorization = "Bearer $Token"; Accept = "application/json"; "OData-MaxVersion" = "4.0"; "OData-Version" = "4.0" }
    $p = @{ Method = $Method; Uri = $uri; Headers = $h }
    if ($Body) { $p.Body = ($Body | ConvertTo-Json -Depth 5); $h["Content-Type"] = "application/json" }
    return Invoke-RestMethod @p
}

Write-Host "===== Dataverse Access Fixer - All Users =====" -ForegroundColor Cyan

# Connect once
Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Yellow
Connect-MgGraph -Scopes "User.Read.All" -TenantId $TenantDomain -NoWelcome | Out-Null
Write-Host "[OK] Connected to Graph as: $((Get-MgContext).Account)" -ForegroundColor Green

Write-Host "Connecting to Power Platform..." -ForegroundColor Yellow
Add-PowerAppsAccount | Out-Null
Write-Host "[OK] Connected to Power Platform" -ForegroundColor Green

# Get environments
$allEnvs = Get-AdminPowerAppEnvironment
$envs = if ($EnvironmentDisplayName) {
    $allEnvs | Where-Object { $_.DisplayName -eq $EnvironmentDisplayName }
} else {
    $allEnvs | Where-Object { -not [string]::IsNullOrWhiteSpace((Get-InstanceUrl -Env $_)) }
}
Write-Host "[OK] Found $($envs.Count) Dataverse environment(s)" -ForegroundColor Green

$results = @()

# Process each user
for ($i = 1; $i -le $UserCount; $i++) {
    $email = "$UsernamePattern-$('{0:D2}' -f $i)@$TenantDomain"
    Write-Host ""
    Write-Host "---- Processing: $email ----" -ForegroundColor Cyan

    try {
        $user = Get-MgUser -Filter "userPrincipalName eq '$email'" -ErrorAction Stop
        if (-not $user) { Write-Host "[SKIP] User not found: $email" -ForegroundColor Yellow; continue }
        Write-Host "[OK] Found user: $($user.DisplayName) ($($user.Id))" -ForegroundColor Green
    }
    catch {
        Write-Host "[ERROR] Could not find user $email : $($_.Exception.Message)" -ForegroundColor Red
        continue
    }

    # Check Power Platform environment roles
    try {
        $ppRoles = Get-AdminPowerAppEnvironmentRoleAssignment -UserId $user.Id
        $hasEnvRole = @($ppRoles | Where-Object { $_.RoleName -in @("EnvironmentAdmin","EnvironmentMaker","SystemAdministrator") }).Count -gt 0
        if ($hasEnvRole) {
            Write-Host "  [OK] Has Power Platform environment role" -ForegroundColor Green
        } else {
            Write-Host "  [WARN] No Power Platform environment role - assigning Environment Maker..." -ForegroundColor Yellow
            foreach ($env in $envs) {
                try {
                    Set-AdminPowerAppEnvironmentRoleAssignment -EnvironmentName $env.EnvironmentName `
                        -RoleName EnvironmentMaker -PrincipalType User -PrincipalObjectId $user.Id | Out-Null
                    Write-Host "  [OK] Assigned EnvironmentMaker in: $($env.DisplayName)" -ForegroundColor Green
                }
                catch {
                    Write-Host "  [ERROR] Could not assign role in $($env.DisplayName): $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }
    }
    catch {
        Write-Host "  [WARN] Could not check PP roles: $($_.Exception.Message)" -ForegroundColor Yellow
    }

    # Check Dataverse roles in each environment
    foreach ($env in $envs) {
        $instanceUrl = Get-InstanceUrl -Env $env
        if (-not $instanceUrl) { continue }
        Write-Host "  Checking Dataverse in: $($env.DisplayName)" -ForegroundColor Gray

        try {
            $tokenJson = az account get-access-token --resource $instanceUrl --output json 2>$null
            if ($LASTEXITCODE -ne 0) { Write-Host "  [WARN] az login needed for $instanceUrl" -ForegroundColor Yellow; continue }
            $token = ($tokenJson | ConvertFrom-Json).accessToken

            $sysResp = Invoke-DvRequest -InstanceUrl $instanceUrl -Token $token `
                -Path "systemusers?`$select=systemuserid&`$filter=azureactivedirectoryobjectid eq $($user.Id)"
            $sysUser = @($sysResp.value) | Select-Object -First 1

            if (-not $sysUser) {
                Write-Host "    [WARN] Not a Dataverse system user yet (may sync automatically after login)" -ForegroundColor Yellow
                $results += [pscustomobject]@{ User = $email; Env = $env.DisplayName; Status = "No Dataverse system user - needs first login" }
                continue
            }

            $rolesResp = Invoke-DvRequest -InstanceUrl $instanceUrl -Token $token `
                -Path "systemusers($($sysUser.systemuserid))/systemuserroles_association?`$select=name"
            $currentRoles = @($rolesResp.value | ForEach-Object { $_.name })

            if ($currentRoles -contains $RoleToAssign) {
                Write-Host "    [OK] Has '$RoleToAssign' role" -ForegroundColor Green
                $results += [pscustomobject]@{ User = $email; Env = $env.DisplayName; Status = "OK - has $RoleToAssign" }
            } else {
                Write-Host "    [INFO] Assigning '$RoleToAssign'..." -ForegroundColor Yellow
                try {
                    $roleResp = Invoke-DvRequest -InstanceUrl $instanceUrl -Token $token `
                        -Path "roles?`$select=roleid,name&`$filter=name eq '$RoleToAssign'"
                    $role = @($roleResp.value) | Select-Object -First 1
                    if ($role) {
                        $body = @{ "@odata.id" = "$instanceUrl/api/data/v9.2/roles($($role.roleid))" }
                        Invoke-DvRequest -InstanceUrl $instanceUrl -Token $token `
                            -Path "systemusers($($sysUser.systemuserid))/systemuserroles_association/`$ref" `
                            -Method "Post" -Body $body | Out-Null
                        Write-Host "    [OK] Assigned '$RoleToAssign'" -ForegroundColor Green
                        $results += [pscustomobject]@{ User = $email; Env = $env.DisplayName; Status = "Fixed - assigned $RoleToAssign" }
                    } else {
                        Write-Host "    [ERROR] Role '$RoleToAssign' not found in Dataverse" -ForegroundColor Red
                        $results += [pscustomobject]@{ User = $email; Env = $env.DisplayName; Status = "ERROR - role not found" }
                    }
                }
                catch {
                    Write-Host "    [ERROR] $($_.Exception.Message)" -ForegroundColor Red
                    $results += [pscustomobject]@{ User = $email; Env = $env.DisplayName; Status = "ERROR - $($_.Exception.Message)" }
                }
            }
        }
        catch {
            Write-Host "  [ERROR] $($_.Exception.Message)" -ForegroundColor Red
            $results += [pscustomobject]@{ User = $email; Env = $env.DisplayName; Status = "ERROR - $($_.Exception.Message)" }
        }
    }
}

Write-Host ""
Write-Host "===== Summary =====" -ForegroundColor Cyan
$results | Format-Table -AutoSize

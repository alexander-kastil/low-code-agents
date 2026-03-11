#Requires -Modules @{ ModuleName="Microsoft.Graph.Users"; ModuleVersion="2.0" }

param(
    [Parameter(Mandatory)]
    [string]$UserEmail
)

function Connect-Graph {
    try {
        $context = Get-MgContext
        if ($null -eq $context) { 
            Connect-MgGraph -Scopes "User.Read.All" -NoWelcome | Out-Null
        }
    }
    catch {
        Connect-MgGraph -Scopes "User.Read.All" -NoWelcome | Out-Null
    }
}

Write-Host "Dataverse Access Permission Fixer"
Write-Host "===================================="
Write-Host ""

Connect-Graph

Write-Host "Looking up user: $UserEmail"
try {
    $user = Get-MgUser -Filter "userPrincipalName eq '$UserEmail'" -ErrorAction Stop
    Write-Host "[OK] Found user: $($user.DisplayName)"
}
catch {
    Write-Host "[ERROR] User not found: $UserEmail"
    exit 1
}

Write-Host ""
Write-Host "To grant Dataverse access, you need to:"
Write-Host "1. Assign the user a Power Platform license (Power Apps Premium)"
Write-Host "2. Assign the user to a Power Platform environment as 'System Customizer' or 'System Administrator'"
Write-Host "3. Create a Dataverse system user for this user"
Write-Host "4. Assign Dataverse security roles"
Write-Host ""
Write-Host "Use the Power Platform admin center or Copilot Studio to configure these permissions:"
Write-Host "- https://admin.powerplatform.microsoft.com"
Write-Host ""

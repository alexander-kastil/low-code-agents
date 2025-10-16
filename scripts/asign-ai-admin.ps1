Import-Module Microsoft.Graph.Identity.Governance -Force

# --- variables ---
$upn = "alexander.kastil@integrations.at"   # target user

# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.Read.All", "RoleManagement.ReadWrite.Directory"

# Resolve user
$user = Get-MgUser -UserId $upn


# Assign roles: AI Administrator, SharePoint Administrator, Teams Administrator
$roleNames = @(
  "AI Administrator",
  "SharePoint Administrator",
  "Teams Administrator"
)
foreach ($roleName in $roleNames) {
  $roleDef = Get-MgRoleManagementDirectoryRoleDefinition -Filter "displayName eq '$roleName'"
  if ($roleDef) {
    New-MgRoleManagementDirectoryRoleAssignment -BodyParameter @{
      "@odata.type"    = "#microsoft.graph.unifiedRoleAssignment"
      roleDefinitionId = $roleDef.Id
      principalId      = $user.Id
      directoryScopeId = "/"
    }
    Write-Host "Assigned role: $roleName"
  } else {
    Write-Host "Role not found: $roleName"
  }
}

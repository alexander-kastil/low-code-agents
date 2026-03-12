# Scripts

| Script                              | Description                                                                                                                                                                             |
| ----------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `asign-ai-admin.ps1`                | Assigns AI Administrator, SharePoint Administrator, and Teams Administrator Entra ID roles to a target user via Microsoft Graph.                                                        |
| `create-copilot-studio-users.ps1`   | Creates Copilot Studio users in bulk, assigns Microsoft 365 licenses, creates Power Platform environments, and grants Dataverse roles using `pac admin assign-user`.                    |
| `get-student-permissions.ps1`       | Generates a JSON permissions report for a student user covering Entra ID directory roles, licenses, and Dataverse security roles. Output is saved to `student-permissions-report.json`. |
| `setup-azure-python-extensions.ps1` | Installs Azure-related VS Code extensions (Azure Functions, etc.) for Python development.                                                                                               |
| `setup-m365-pilot.ps1`              | Installs all developer prerequisites via `winget` and `npm` (Node.js, .NET SDK, Azure CLI, `azd`, dev tunnels, M365 Agents Toolkit CLI, PowerShell modules, etc.).                      |
| `setup-vscode-extensions.ps1`       | Installs the VS Code extensions listed in the devcontainer configuration (.NET, Docker, Copilot, Prettier, and others).                                                                 |
| `truncate-history.ps1`              | Squashes the entire git history to a single commit by creating a new orphan branch, then force-pushes it to replace the remote `master` branch.                                         |

## Prerequisites

Some scripts require the Microsoft Power Platform CLI (`pac`).

Install it with `winget`:

```powershell
winget install --id Microsoft.PowerAppsCLI -e
```

### Verify installation

```powershell
Get-Command pac | Format-List
pac
```

### Authenticate PAC CLI

Before running scripts that assign users to Power Platform environments, authenticate once:

```powershell
pac auth create
```

Verify access:

```powershell
pac admin list --json
```

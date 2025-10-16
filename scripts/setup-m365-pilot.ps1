winget install --id Microsoft.DotNet.SDK.9 --exact --accept-package-agreements --accept-source-agreements
winget install --id OpenJS.NodeJS --exact --version 22.18.0 --accept-package-agreements --accept-source-agreements
winget install --id Python.Python.3.11 --exact --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.PowerShell --exact --accept-package-agreements --accept-source-agreements
winget install --id Git.Git --exact --accept-package-agreements --accept-source-agreements
winget install --id GitHub.cli --exact --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.AzureCLI --exact --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.Azd --exact --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.AzureFunctionsCoreTools --exact --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.DevTunnelCLI --exact --accept-package-agreements --accept-source-agreements

npm install -g azure-functions-core-tools@4 --unsafe-perm true
npm install -g azurite
npm install -g @microsoft/m365agentstoolkit-cli
npm install -g @microsoft/m365agentsplayground
npm install -g @microsoft/teams.cli

dotnet tool install --global Microsoft.OpenApi.Kiota

pwsh -NoLogo -NoProfile -Command "Set-PSRepository -Name PSGallery -InstallationPolicy Trusted; Install-Module Microsoft.Graph -Scope CurrentUser -Force -AllowClobber; Install-Module Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser -Force -AllowClobber"

Write-Host "Setup complete. Open a new terminal to pick up any PATH updates." -ForegroundColor Green
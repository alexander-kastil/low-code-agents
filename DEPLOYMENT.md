# Deployment Guide

This guide covers deploying the m365-copilot project to Azure using Azure Developer CLI (azd) and GitHub Actions.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Local Deployment with azd](#local-deployment-with-azd)
- [CI/CD with GitHub Actions](#cicd-with-github-actions)
- [Manual Deployment (Legacy)](#manual-deployment-legacy)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Tools

1. **Azure Developer CLI (azd)**
   ```bash
   # Windows (PowerShell)
   winget install microsoft.azd
   
   # macOS
   brew tap azure/azd && brew install azd
   
   # Linux
   curl -fsSL https://aka.ms/install-azd.sh | bash
   ```

2. **Azure CLI** (for advanced scenarios)
   ```bash
   # Installation instructions at:
   # https://learn.microsoft.com/en-us/cli/azure/install-azure-cli
   ```

3. **.NET 9.0 SDK** (for local development)
   - Download from https://dotnet.microsoft.com/download

4. **Node.js 22.x** (for food-shop frontend)
   - Download from https://nodejs.org/

### Azure Requirements

- Azure subscription
- Permissions to create resources in the subscription
- Resource quota for:
  - App Service Plans
  - Web Apps
  - Static Web Apps
  - Storage Accounts

## Local Deployment with azd

### First-Time Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/alexander-kastil/m365-copilot.git
   cd m365-copilot
   ```

2. **Login to Azure**
   ```bash
   azd auth login
   ```

3. **Initialize a new environment**
   ```bash
   azd env new
   ```
   
   When prompted:
   - **Environment name**: Choose a name (e.g., `dev`, `staging`, `prod`)
   - **Subscription**: Select your Azure subscription
   - **Location**: Select Azure region (e.g., `westeurope`, `eastus`)

4. **Provision and deploy**
   ```bash
   azd up
   ```
   
   This single command will:
   - Create all Azure resources
   - Build all services
   - Deploy all services

### Subsequent Deployments

After initial setup, you can use these commands:

- **Deploy code changes only**:
  ```bash
  azd deploy
  ```

- **Update infrastructure only**:
  ```bash
  azd provision
  ```

- **Deploy specific service**:
  ```bash
  azd deploy food-catalog-api
  azd deploy hr-mcp-server
  azd deploy purchasing-service
  azd deploy food-shop
  ```

- **View deployed resources**:
  ```bash
  azd show
  ```

- **Get service endpoints**:
  ```bash
  azd env get-values
  ```

### Clean Up

To remove all deployed resources:

```bash
azd down
```

⚠️ **Warning**: This will delete all resources in the resource group!

## CI/CD with GitHub Actions

### Setup

1. **Create a Service Principal with Federated Credentials**
   
   ```bash
   # Set variables
   SUBSCRIPTION_ID=$(az account show --query id -o tsv)
   REPO_OWNER="alexander-kastil"
   REPO_NAME="m365-copilot"
   
   # Create service principal
   az ad sp create-for-rbac --name "m365-copilot-github" \
     --role contributor \
     --scopes /subscriptions/$SUBSCRIPTION_ID \
     --sdk-auth
   ```
   
   Save the output JSON for the next step.

2. **Configure Federated Identity Credentials**
   
   ```bash
   APP_ID=$(az ad sp list --display-name "m365-copilot-github" --query "[0].appId" -o tsv)
   
   # For main branch
   az ad app federated-credential create \
     --id $APP_ID \
     --parameters '{
       "name": "m365-copilot-github-main",
       "issuer": "https://token.actions.githubusercontent.com",
       "subject": "repo:'$REPO_OWNER'/'$REPO_NAME':ref:refs/heads/master",
       "audiences": ["api://AzureADTokenExchange"]
     }'
   ```

3. **Add GitHub Secrets**
   
   Go to your GitHub repository → Settings → Secrets and variables → Actions
   
   Add the following secrets:
   - `AZURE_CLIENT_ID` - Application (client) ID
   - `AZURE_TENANT_ID` - Directory (tenant) ID
   - `AZURE_SUBSCRIPTION_ID` - Subscription ID
   - `FOOD_CATALOG_API_NAME` - Name of food catalog API app
   - `HR_MCP_SERVER_NAME` - Name of HR MCP server app
   - `PURCHASING_SERVICE_NAME` - Name of purchasing service app
   - `AZURE_STATIC_WEB_APPS_API_TOKEN` - Static Web App deployment token

4. **Get App Service Names**
   
   After first deployment with azd:
   ```bash
   azd env get-values | grep "_NAME"
   ```

5. **Get Static Web App Token**
   
   ```bash
   az staticwebapp secrets list \
     --name <static-web-app-name> \
     --query "properties.apiKey" -o tsv
   ```

### Workflows

The repository includes four CI/CD workflows:

1. **food-catalog-api-ci-cd.yml**
   - Triggers on push to `master` or workflow_dispatch
   - Builds and deploys the food catalog API
   - Path filter: `src/food-catalog-api/**`

2. **hr-mcp-server-ci-cd.yml**
   - Triggers on push to `master` or workflow_dispatch
   - Builds and deploys the HR MCP server
   - Path filter: `src/hr-mcp-server/**`

3. **purchasing-service-ci-cd.yml**
   - Triggers on push to `master` or workflow_dispatch
   - Builds and deploys the purchasing service
   - Path filter: `src/purchasing-service/**`

4. **food-shop-ci-cd.yml**
   - Manual trigger only (workflow_dispatch)
   - Builds and deploys the Angular frontend

### Manual Workflow Trigger

To manually trigger a workflow:

1. Go to Actions tab in GitHub
2. Select the workflow
3. Click "Run workflow"
4. Select branch and click "Run workflow"

## Manual Deployment (Legacy)

The repository includes legacy deployment scripts for reference:

- `src/deploy-apis.azcli` - Bash script using Azure CLI
- `src/deploy-apis.ps1` - PowerShell script using Azure CLI

**Note**: These scripts are replaced by the azd approach but kept for reference.

## Configuration

### Environment Variables

After deployment, these environment variables are available:

```bash
# Get all environment variables
azd env get-values

# Get specific values
azd env get-value FOOD_CATALOG_API_URI
azd env get-value HR_MCP_SERVER_URI
azd env get-value PURCHASING_SERVICE_URI
azd env get-value STATIC_WEB_APP_URI
```

### Customizing Resource Names

Override default names by setting environment variables before provisioning:

```bash
azd env set STORAGE_ACCOUNT_NAME myuniquestorage123
azd env set FOOD_CATALOG_API_NAME my-food-api
azd env set HR_MCP_SERVER_NAME my-hr-server
azd env set PURCHASING_SERVICE_NAME my-purchasing-svc
azd env set STATIC_WEB_APP_NAME my-food-shop
```

### Customizing SKUs and Tiers

Edit `infra/main.bicep` to modify SKUs:

```bicep
module appServicePlan './app-service-plan.bicep' = {
  params: {
    sku: {
      name: 'S1'  // Change from B1 to S1
      tier: 'Standard'
    }
  }
}
```

## Troubleshooting

### Common Issues

1. **"Resource name already exists"**
   
   Use unique names:
   ```bash
   azd env set STORAGE_ACCOUNT_NAME myuniquestorage$RANDOM
   azd provision
   ```

2. **"Insufficient permissions"**
   
   Ensure you have Contributor role on the subscription:
   ```bash
   az role assignment create \
     --assignee <your-user-id> \
     --role Contributor \
     --scope /subscriptions/<subscription-id>
   ```

3. **"Deployment failed"**
   
   Check deployment logs:
   ```bash
   azd deploy --debug
   ```

4. **"Static Web App deployment failed"**
   
   Verify the dist path in azure.yaml matches the Angular build output.

5. **GitHub Actions failing**
   
   - Verify all secrets are set correctly
   - Check that federated credentials subject matches your branch
   - Ensure service principal has Contributor role

### Getting Help

- View deployment logs: `azd deploy --debug`
- View provisioning logs: `azd provision --debug`
- Check resource status in Azure Portal
- Review GitHub Actions logs in the Actions tab

### Useful Commands

```bash
# View all resources
azd show

# View logs
azd monitor

# Get environment info
azd env list
azd env get-values

# Refresh environment
azd provision

# Reset environment
azd down
azd up
```

## Architecture

The deployment creates the following architecture:

```
Azure Subscription
└── Resource Group (rg-{env-name})
    ├── Storage Account
    │   └── Blob Container (food)
    ├── App Service Plan (Linux, B1)
    │   ├── food-catalog-api
    │   ├── hr-mcp-server
    │   └── purchasing-service
    └── Static Web App
        └── food-shop
```

## Security Best Practices

1. **Use Managed Identities** where possible (future enhancement)
2. **Store secrets in Azure Key Vault** (not implemented yet)
3. **Use federated credentials** for GitHub Actions (implemented)
4. **Enable HTTPS only** (implemented)
5. **Restrict CORS** to specific origins in production
6. **Use private endpoints** for storage in production (optional)

## Cost Optimization

Current setup uses:
- **App Service Plan**: B1 (Basic) - ~$13/month
- **Static Web App**: Free tier
- **Storage Account**: Standard LRS - ~$0.05/GB/month

To reduce costs:
- Use F1 (Free) tier for App Service Plan during development
- Delete resources when not in use with `azd down`

## Next Steps

1. Configure custom domains
2. Set up Application Insights for monitoring
3. Configure automated backups
4. Set up staging slots for zero-downtime deployments
5. Implement Azure Key Vault for secrets management
6. Configure managed identities

## References

- [Azure Developer CLI Documentation](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/)
- [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [GitHub Actions for Azure](https://github.com/Azure/actions)
- [Azure App Service Documentation](https://learn.microsoft.com/en-us/azure/app-service/)

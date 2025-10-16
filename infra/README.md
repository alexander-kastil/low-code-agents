# Infrastructure as Code using Azure Developer CLI (azd)

This directory contains the Infrastructure as Code (IaC) configuration for deploying the m365-copilot project using Azure Developer CLI (azd).

## Prerequisites

- [Azure Developer CLI (azd)](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Azure subscription

## Project Structure

```
infra/
├── main.bicep                  # Main entry point for infrastructure deployment
├── main.parameters.json        # Parameters for the deployment
├── storage.bicep              # Storage account module
├── app-service-plan.bicep     # App Service Plan module
├── app-service.bicep          # App Service module (reusable)
└── static-web-app.bicep       # Static Web App module
```

## Resources Deployed

The infrastructure deploys the following Azure resources:

1. **Resource Group** - Contains all resources
2. **Storage Account** - For blob storage (food images)
3. **App Service Plan** - Linux-based plan for hosting .NET 9.0 APIs
4. **App Services** (3):
   - `food-catalog-api` - Food catalog management API
   - `hr-mcp-server` - HR MCP server
   - `purchasing-service` - Purchasing service API
5. **Static Web App** - For hosting the Angular food-shop UI

## Getting Started

### 1. Login to Azure

```bash
azd auth login
```

### 2. Initialize the environment

```bash
azd env new
```

You'll be prompted to provide:
- Environment name (e.g., `dev`, `prod`)
- Azure subscription
- Azure region (e.g., `westeurope`)

### 3. Provision infrastructure

```bash
azd provision
```

This will:
- Create the resource group
- Deploy all Azure resources defined in the bicep files
- Configure the services

### 4. Deploy applications

```bash
azd deploy
```

This will build and deploy all services defined in `azure.yaml`:
- food-catalog-api
- hr-mcp-server
- purchasing-service
- food-shop

### 5. Combined provision and deploy

```bash
azd up
```

This runs both provision and deploy in one command.

## Environment Variables

After provisioning, azd will automatically set environment variables based on the outputs from `main.bicep`. These include:

- `AZURE_LOCATION` - Azure region
- `AZURE_TENANT_ID` - Azure tenant ID
- `AZURE_SUBSCRIPTION_ID` - Azure subscription ID
- `STORAGE_ACCOUNT_NAME` - Name of the storage account
- `FOOD_CATALOG_API_URI` - URL of the food catalog API
- `HR_MCP_SERVER_URI` - URL of the HR MCP server
- `PURCHASING_SERVICE_URI` - URL of the purchasing service
- `STATIC_WEB_APP_URI` - URL of the static web app

## Cleanup

To remove all resources:

```bash
azd down
```

## Customization

### Modifying Resource Names

You can override default resource names by setting parameters:

```bash
azd env set STORAGE_ACCOUNT_NAME myuniquestoragename
azd env set FOOD_CATALOG_API_NAME myfoodapi
```

### Changing SKUs

Edit `infra/main.bicep` and modify the SKU parameters in the module calls.

## CI/CD Integration

GitHub Actions workflows are configured for automated deployments:

- `.github/workflows/food-catalog-api-ci-cd.yml`
- `.github/workflows/hr-mcp-server-ci-cd.yml`
- `.github/workflows/purchasing-service-ci-cd.yml`
- `.github/workflows/food-shop-ci-cd.yml`

These workflows require the following GitHub secrets:
- `AZURE_CLIENT_ID`
- `AZURE_TENANT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `FOOD_CATALOG_API_NAME`
- `HR_MCP_SERVER_NAME`
- `PURCHASING_SERVICE_NAME`
- `AZURE_STATIC_WEB_APPS_API_TOKEN`

## Learn More

- [Azure Developer CLI Documentation](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/)
- [Bicep Documentation](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/)
- [Azure App Service Documentation](https://learn.microsoft.com/en-us/azure/app-service/)

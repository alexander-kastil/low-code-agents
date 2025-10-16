targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the environment which is used to generate a short unique hash used in all resources.')
param environmentName string

@minLength(1)
@description('Primary location for all resources')
param location string

// Optional parameters
param storageAccountName string = ''
param foodCatalogApiName string = ''
param hrMcpServerName string = ''
param purchasingServiceName string = ''
param staticWebAppName string = ''
param appServicePlanName string = ''

// Tags that should be applied to all resources
var tags = {
  'azd-env-name': environmentName
}

// Generate a unique token to be used in naming resources
var resourceToken = toLower(uniqueString(subscription().id, environmentName, location))

// Organize resources in a resource group
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${environmentName}'
  location: location
  tags: tags
}

// Storage account for blob storage
module storage './storage.bicep' = {
  name: 'storage'
  scope: rg
  params: {
    name: !empty(storageAccountName) ? storageAccountName : 'm365copilot${resourceToken}'
    location: location
    tags: tags
  }
}

// App Service Plan for API services
module appServicePlan './app-service-plan.bicep' = {
  name: 'appServicePlan'
  scope: rg
  params: {
    name: !empty(appServicePlanName) ? appServicePlanName : 'plan-${resourceToken}'
    location: location
    tags: tags
    sku: {
      name: 'B1'
      tier: 'Basic'
    }
    kind: 'linux'
  }
}

// Food Catalog API
module foodCatalogApi './app-service.bicep' = {
  name: 'foodCatalogApi'
  scope: rg
  params: {
    name: !empty(foodCatalogApiName) ? foodCatalogApiName : 'food-catalog-api-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': 'food-catalog-api' })
    appServicePlanId: appServicePlan.outputs.id
    runtimeName: 'dotnetcore'
    runtimeVersion: '9.0'
    appSettings: {
      STORAGE_ACCOUNT_NAME: storage.outputs.name
    }
  }
}

// HR MCP Server
module hrMcpServer './app-service.bicep' = {
  name: 'hrMcpServer'
  scope: rg
  params: {
    name: !empty(hrMcpServerName) ? hrMcpServerName : 'hr-mcp-server-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': 'hr-mcp-server' })
    appServicePlanId: appServicePlan.outputs.id
    runtimeName: 'dotnetcore'
    runtimeVersion: '9.0'
    appSettings: {}
  }
}

// Purchasing Service
module purchasingService './app-service.bicep' = {
  name: 'purchasingService'
  scope: rg
  params: {
    name: !empty(purchasingServiceName) ? purchasingServiceName : 'purchasing-service-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': 'purchasing-service' })
    appServicePlanId: appServicePlan.outputs.id
    runtimeName: 'dotnetcore'
    runtimeVersion: '9.0'
    appSettings: {}
  }
}

// Static Web App for food-shop
module staticWebApp './static-web-app.bicep' = {
  name: 'staticWebApp'
  scope: rg
  params: {
    name: !empty(staticWebAppName) ? staticWebAppName : 'food-shop-${resourceToken}'
    location: location
    tags: union(tags, { 'azd-service-name': 'food-shop' })
    sku: 'Free'
  }
}

// Outputs
output AZURE_LOCATION string = location
output AZURE_TENANT_ID string = tenant().tenantId
output AZURE_SUBSCRIPTION_ID string = subscription().subscriptionId

output STORAGE_ACCOUNT_NAME string = storage.outputs.name
output STORAGE_ACCOUNT_KEY string = storage.outputs.primaryKey

output FOOD_CATALOG_API_NAME string = foodCatalogApi.outputs.name
output FOOD_CATALOG_API_URI string = foodCatalogApi.outputs.uri

output HR_MCP_SERVER_NAME string = hrMcpServer.outputs.name
output HR_MCP_SERVER_URI string = hrMcpServer.outputs.uri

output PURCHASING_SERVICE_NAME string = purchasingService.outputs.name
output PURCHASING_SERVICE_URI string = purchasingService.outputs.uri

output STATIC_WEB_APP_NAME string = staticWebApp.outputs.name
output STATIC_WEB_APP_URI string = staticWebApp.outputs.uri

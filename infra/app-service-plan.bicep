@description('Name of the App Service Plan')
param name string

@description('Location for the App Service Plan')
param location string = resourceGroup().location

@description('Tags to apply to the App Service Plan')
param tags object = {}

@description('SKU configuration for the App Service Plan')
param sku object = {
  name: 'B1'
  tier: 'Basic'
}

@description('Kind of App Service Plan (linux or windows)')
param kind string = 'linux'

resource appServicePlan 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: sku
  kind: kind
  properties: {
    reserved: kind == 'linux' ? true : false
  }
}

output id string = appServicePlan.id
output name string = appServicePlan.name

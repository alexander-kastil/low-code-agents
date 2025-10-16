@description('Name of the Static Web App')
param name string

@description('Location for the Static Web App')
param location string = resourceGroup().location

@description('Tags to apply to the Static Web App')
param tags object = {}

@description('SKU tier (Free or Standard)')
param sku string = 'Free'

resource staticWebApp 'Microsoft.Web/staticSites@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: sku
    tier: sku
  }
  properties: {
    allowConfigFileUpdates: true
    stagingEnvironmentPolicy: 'Enabled'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

output id string = staticWebApp.id
output name string = staticWebApp.name
output uri string = 'https://${staticWebApp.properties.defaultHostname}'
// azd requires this output for deployment
#disable-next-line outputs-should-not-contain-secrets
output apiKey string = staticWebApp.listSecrets().properties.apiKey

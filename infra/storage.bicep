@description('Name of the storage account')
param name string

@description('Location for the storage account')
param location string = resourceGroup().location

@description('Tags to apply to the storage account')
param tags object = {}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

// Create blob service
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  parent: storageAccount
  name: 'default'
}

// Create 'food' container for images
resource foodContainer 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  parent: blobService
  name: 'food'
  properties: {
    publicAccess: 'Blob'
  }
}

output id string = storageAccount.id
output name string = storageAccount.name
// azd requires this output for service configuration
#disable-next-line outputs-should-not-contain-secrets
output primaryKey string = storageAccount.listKeys().keys[0].value
output primaryEndpoint string = storageAccount.properties.primaryEndpoints.blob

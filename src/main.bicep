param sites_hr_mcp_server_dev_name string = 'hr-mcp-server-dev'
param staticSites_food_shop_ui_name string = 'food-shop-ui'
param sites_food_catalog_api_dev_name string = 'food-catalog-api-dev'
param sites_purchasing_service_dev_name string = 'purchasing-service-dev'
param serverfarms_copilot_hr_plan_dev_name string = 'copilot-hr-plan-dev'
param serverfarms_copilot_food_plan_dev_name string = 'copilot-food-plan-dev'
param storageAccounts_m365copilotdev_name string = 'm365copilotdev'
param serverfarms_copilot_purchasing_plan_dev_name string = 'copilot-purchasing-plan-dev'

resource storageAccounts_m365copilotdev_name_resource 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccounts_m365copilotdev_name
  location: 'westeurope'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: false
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: true
    allowSharedKeyAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource serverfarms_copilot_food_plan_dev_name_resource 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: serverfarms_copilot_food_plan_dev_name
  location: 'West Europe'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    asyncScalingEnabled: false
  }
}

resource serverfarms_copilot_hr_plan_dev_name_resource 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: serverfarms_copilot_hr_plan_dev_name
  location: 'West Europe'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    asyncScalingEnabled: false
  }
}

resource serverfarms_copilot_purchasing_plan_dev_name_resource 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: serverfarms_copilot_purchasing_plan_dev_name
  location: 'West Europe'
  sku: {
    name: 'F1'
    tier: 'Free'
    size: 'F1'
    family: 'F'
    capacity: 0
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    asyncScalingEnabled: false
  }
}

resource staticSites_food_shop_ui_name_resource 'Microsoft.Web/staticSites@2024-11-01' = {
  name: staticSites_food_shop_ui_name
  location: 'West Europe'
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    repositoryUrl: 'https://github.com/alexander-kastil/m365-copilot'
    branch: 'master'
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'GitHub'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource storageAccounts_m365copilotdev_name_default 'Microsoft.Storage/storageAccounts/blobServices@2025-01-01' = {
  parent: storageAccounts_m365copilotdev_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_m365copilotdev_name_default 'Microsoft.Storage/storageAccounts/fileServices@2025-01-01' = {
  parent: storageAccounts_m365copilotdev_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_m365copilotdev_name_default 'Microsoft.Storage/storageAccounts/queueServices@2025-01-01' = {
  parent: storageAccounts_m365copilotdev_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_m365copilotdev_name_default 'Microsoft.Storage/storageAccounts/tableServices@2025-01-01' = {
  parent: storageAccounts_m365copilotdev_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_food_catalog_api_dev_name_resource 'Microsoft.Web/sites@2024-11-01' = {
  name: sites_food_catalog_api_dev_name
  location: 'West Europe'
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_food_catalog_api_dev_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_food_catalog_api_dev_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_copilot_food_plan_dev_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    outboundVnetRouting: {
      allTraffic: false
      applicationTraffic: false
      contentShareTraffic: false
      imagePullTraffic: false
      backupRestoreTraffic: false
    }
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientAffinityProxyEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    customDomainVerificationId: '1A7E116ED6934625FBEA7701F8B25119E474E48CB44851A6B8B581C4279228BC'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_hr_mcp_server_dev_name_resource 'Microsoft.Web/sites@2024-11-01' = {
  name: sites_hr_mcp_server_dev_name
  location: 'West Europe'
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_hr_mcp_server_dev_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_hr_mcp_server_dev_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_copilot_hr_plan_dev_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    outboundVnetRouting: {
      allTraffic: false
      applicationTraffic: false
      contentShareTraffic: false
      imagePullTraffic: false
      backupRestoreTraffic: false
    }
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientAffinityProxyEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    customDomainVerificationId: '1A7E116ED6934625FBEA7701F8B25119E474E48CB44851A6B8B581C4279228BC'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_purchasing_service_dev_name_resource 'Microsoft.Web/sites@2024-11-01' = {
  name: sites_purchasing_service_dev_name
  location: 'West Europe'
  kind: 'app'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: '${sites_purchasing_service_dev_name}.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: '${sites_purchasing_service_dev_name}.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_copilot_purchasing_plan_dev_name_resource.id
    reserved: false
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    outboundVnetRouting: {
      allTraffic: false
      applicationTraffic: false
      contentShareTraffic: false
      imagePullTraffic: false
      backupRestoreTraffic: false
    }
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: true
      functionAppScaleLimit: 0
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: true
    clientAffinityProxyEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    customDomainVerificationId: '1A7E116ED6934625FBEA7701F8B25119E474E48CB44851A6B8B581C4279228BC'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_food_catalog_api_dev_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_food_catalog_api_dev_name_resource
  name: 'ftp'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_hr_mcp_server_dev_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_hr_mcp_server_dev_name_resource
  name: 'ftp'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_purchasing_service_dev_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_purchasing_service_dev_name_resource
  name: 'ftp'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_food_catalog_api_dev_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_food_catalog_api_dev_name_resource
  name: 'scm'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_hr_mcp_server_dev_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_hr_mcp_server_dev_name_resource
  name: 'scm'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_purchasing_service_dev_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-11-01' = {
  parent: sites_purchasing_service_dev_name_resource
  name: 'scm'
  location: 'West Europe'
  properties: {
    allow: false
  }
}

resource sites_food_catalog_api_dev_name_web 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: sites_food_catalog_api_dev_name_resource
  name: 'web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v9.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: true
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 100
    detailedErrorLoggingEnabled: false
    publishingUsername: 'REDACTED'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    cors: {
      allowedOrigins: [
        '*'
      ]
      supportCredentials: false
    }
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: true
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
    http20ProxyFlag: 0
  }
}

resource sites_hr_mcp_server_dev_name_web 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: sites_hr_mcp_server_dev_name_resource
  name: 'web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v9.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: true
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 100
    detailedErrorLoggingEnabled: false
    publishingUsername: 'REDACTED'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: true
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
    http20ProxyFlag: 0
  }
}

resource sites_purchasing_service_dev_name_web 'Microsoft.Web/sites/config@2024-11-01' = {
  parent: sites_purchasing_service_dev_name_resource
  name: 'web'
  location: 'West Europe'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
      'hostingstart.html'
    ]
    netFrameworkVersion: 'v9.0'
    phpVersion: '5.6'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: true
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 100
    detailedErrorLoggingEnabled: false
    publishingUsername: 'REDACTED'
    scmType: 'None'
    use32BitWorkerProcess: true
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: true
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    elasticWebAppScaleLimit: 0
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
    http20ProxyFlag: 0
  }
}

resource sites_food_catalog_api_dev_name_1fc1b77c169e4f57afa241662f7d5585 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_food_catalog_api_dev_name_resource
  name: '1fc1b77c169e4f57afa241662f7d5585'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-10-04T08:47:44.2515304Z'
    end_time: '2025-10-04T08:48:09.0811085Z'
    active: false
  }
}

resource sites_purchasing_service_dev_name_34508753e5fa44ae8d3836fc94b98862 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_purchasing_service_dev_name_resource
  name: '34508753e5fa44ae8d3836fc94b98862'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-10-04T22:53:01.0358019Z'
    end_time: '2025-10-04T22:53:15.3954213Z'
    active: true
  }
}

resource sites_hr_mcp_server_dev_name_53237649b45346b3885cb59b4a6629e1 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_hr_mcp_server_dev_name_resource
  name: '53237649b45346b3885cb59b4a6629e1'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-10-04T06:29:39.3380863Z'
    end_time: '2025-10-04T06:30:37.1743216Z'
    active: true
  }
}

resource sites_food_catalog_api_dev_name_d9881d6eee404fd8a62de2a2da2489c3 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_food_catalog_api_dev_name_resource
  name: 'd9881d6eee404fd8a62de2a2da2489c3'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-10-04T22:19:26.6572055Z'
    end_time: '2025-10-04T22:20:38.4656078Z'
    active: true
  }
}

resource sites_purchasing_service_dev_name_da6dd9c2f93947f9bdb1bb1dd888c0ca 'Microsoft.Web/sites/deployments@2024-11-01' = {
  parent: sites_purchasing_service_dev_name_resource
  name: 'da6dd9c2f93947f9bdb1bb1dd888c0ca'
  location: 'West Europe'
  properties: {
    status: 4
    author_email: 'N/A'
    author: 'N/A'
    deployer: 'ZipDeploy'
    message: 'Created via a push deployment'
    start_time: '2025-10-04T20:47:04.0601451Z'
    end_time: '2025-10-04T20:47:27.1239187Z'
    active: false
  }
}

resource sites_food_catalog_api_dev_name_sites_food_catalog_api_dev_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-11-01' = {
  parent: sites_food_catalog_api_dev_name_resource
  name: '${sites_food_catalog_api_dev_name}.azurewebsites.net'
  location: 'West Europe'
  properties: {
    siteName: 'food-catalog-api-dev'
    hostNameType: 'Verified'
  }
}

resource sites_hr_mcp_server_dev_name_sites_hr_mcp_server_dev_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-11-01' = {
  parent: sites_hr_mcp_server_dev_name_resource
  name: '${sites_hr_mcp_server_dev_name}.azurewebsites.net'
  location: 'West Europe'
  properties: {
    siteName: 'hr-mcp-server-dev'
    hostNameType: 'Verified'
  }
}

resource sites_purchasing_service_dev_name_sites_purchasing_service_dev_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-11-01' = {
  parent: sites_purchasing_service_dev_name_resource
  name: '${sites_purchasing_service_dev_name}.azurewebsites.net'
  location: 'West Europe'
  properties: {
    siteName: 'purchasing-service-dev'
    hostNameType: 'Verified'
  }
}

resource staticSites_food_shop_ui_name_default 'Microsoft.Web/staticSites/basicAuth@2024-11-01' = {
  parent: staticSites_food_shop_ui_name_resource
  name: 'default'
  location: 'West Europe'
  properties: {
    applicableEnvironmentsMode: 'SpecifiedEnvironments'
  }
}

resource storageAccounts_m365copilotdev_name_default_food 'Microsoft.Storage/storageAccounts/blobServices/containers@2025-01-01' = {
  parent: storageAccounts_m365copilotdev_name_default
  name: 'food'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'Blob'
  }
  dependsOn: [
    storageAccounts_m365copilotdev_name_resource
  ]
}

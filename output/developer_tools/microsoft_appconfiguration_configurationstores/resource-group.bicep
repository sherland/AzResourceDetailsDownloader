param configurationStores_appcs1y_1kv59_name string

resource configurationStores_appcs1y_1kv59_name_resource 'Microsoft.AppConfiguration/configurationStores@2025-06-01-preview' = {
  name: configurationStores_appcs1y_1kv59_name
  location: 'westeurope'
  sku: {
    name: 'free'
  }
  properties: {
    encryption: {}
    disableLocalAuth: false
    softDeleteRetentionInDays: 0
    defaultKeyValueRevisionRetentionPeriodInSeconds: 604800
    enablePurgeProtection: false
    dataPlaneProxy: {
      authenticationMode: 'Local'
      privateLinkDelegation: 'Disabled'
    }
    telemetry: {}
    azureFrontDoor: {}
  }
}


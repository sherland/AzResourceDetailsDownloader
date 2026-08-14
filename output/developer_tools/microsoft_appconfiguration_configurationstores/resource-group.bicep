param configurationStores_appcskiph6ald_name string

resource configurationStores_appcskiph6ald_name_resource 'Microsoft.AppConfiguration/configurationStores@2025-06-01-preview' = {
  name: configurationStores_appcskiph6ald_name
  location: 'norwayeast'
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


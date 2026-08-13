param configurationStores_appcslcx_jhpz_name string

resource configurationStores_appcslcx_jhpz_name_resource 'Microsoft.AppConfiguration/configurationStores@2025-06-01-preview' = {
  name: configurationStores_appcslcx_jhpz_name
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


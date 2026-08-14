param configurationStores_appcs1w6r_t_z_name string

resource configurationStores_appcs1w6r_t_z_name_resource 'Microsoft.AppConfiguration/configurationStores@2025-06-01-preview' = {
  name: configurationStores_appcs1w6r_t_z_name
  location: 'norwayeast'
  sku: {
    name: 'standard'
  }
  properties: {
    encryption: {}
    disableLocalAuth: false
    softDeleteRetentionInDays: 7
    defaultKeyValueRevisionRetentionPeriodInSeconds: 2592000
    enablePurgeProtection: false
    dataPlaneProxy: {
      authenticationMode: 'Local'
      privateLinkDelegation: 'Disabled'
    }
    telemetry: {}
    azureFrontDoor: {}
  }
}


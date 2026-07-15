param dataCollectionEndpoints_dcemegmb_xy_name string

resource dataCollectionEndpoints_dcemegmb_xy_name_resource 'Microsoft.Insights/dataCollectionEndpoints@2024-03-11' = {
  name: dataCollectionEndpoints_dcemegmb_xy_name
  location: 'westeurope'
  properties: {
    immutableId: 'dce-ca2ae64a89d043eab3b5de7ef37615f9'
    configurationAccess: {}
    logsIngestion: {}
    metricsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
}


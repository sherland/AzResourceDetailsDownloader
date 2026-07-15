param dataCollectionEndpoints_dcemegmb_xy_name string

resource dataCollectionEndpoints_dcemegmb_xy_name_resource 'Microsoft.Insights/dataCollectionEndpoints@2024-03-11' = {
  name: dataCollectionEndpoints_dcemegmb_xy_name
  location: 'westeurope'
  properties: {
    immutableId: 'dce-8ae9e0dda4d44b0bb45d3213d8761428'
    configurationAccess: {}
    logsIngestion: {}
    metricsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
}


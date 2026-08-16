param dataCollectionEndpoints_dcemegmb_xy_name string

resource dataCollectionEndpoints_dcemegmb_xy_name_resource 'Microsoft.Insights/dataCollectionEndpoints@2024-03-11' = {
  name: dataCollectionEndpoints_dcemegmb_xy_name
  location: 'norwayeast'
  properties: {
    immutableId: 'dce-cad18d2620914966b0e340463a53fa39'
    configurationAccess: {}
    logsIngestion: {}
    metricsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
}


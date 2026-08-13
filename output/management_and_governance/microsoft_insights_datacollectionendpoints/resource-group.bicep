param dataCollectionEndpoints_dcemegmb_xy_name string

resource dataCollectionEndpoints_dcemegmb_xy_name_resource 'Microsoft.Insights/dataCollectionEndpoints@2024-03-11' = {
  name: dataCollectionEndpoints_dcemegmb_xy_name
  location: 'norwayeast'
  properties: {
    immutableId: 'dce-59a7573b254741b99ba0f964365698c8'
    configurationAccess: {}
    logsIngestion: {}
    metricsIngestion: {}
    networkAcls: {
      publicNetworkAccess: 'Enabled'
    }
  }
}


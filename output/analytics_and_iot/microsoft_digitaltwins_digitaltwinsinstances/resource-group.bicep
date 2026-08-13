param digitalTwinsInstances_dt4wdx8el0_name string

resource digitalTwinsInstances_dt4wdx8el0_name_resource 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' = {
  name: digitalTwinsInstances_dt4wdx8el0_name
  location: 'northeurope'
  properties: {
    privateEndpointConnections: []
    publicNetworkAccess: 'Enabled'
  }
}


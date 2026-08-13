param serverfarms_planxsbsuyv2_name string
param autoscalesettings_asp_mww_u3_name string

resource serverfarms_planxsbsuyv2_name_resource 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: serverfarms_planxsbsuyv2_name
  location: 'Sweden Central'
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    asyncScalingEnabled: false
  }
}

resource autoscalesettings_asp_mww_u3_name_resource 'microsoft.insights/autoscalesettings@2022-10-01' = {
  name: autoscalesettings_asp_mww_u3_name
  location: 'swedencentral'
  properties: {
    profiles: [
      {
        name: 'default'
        capacity: {
          minimum: '1'
          maximum: '1'
          default: '1'
        }
        rules: []
      }
    ]
    enabled: true
    name: autoscalesettings_asp_mww_u3_name
    targetResourceUri: serverfarms_planxsbsuyv2_name_resource.id
    predictiveAutoscalePolicy: {
      scaleMode: 'Disabled'
    }
  }
}


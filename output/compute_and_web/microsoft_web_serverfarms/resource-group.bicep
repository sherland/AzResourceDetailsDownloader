param serverfarms_planvwrvnc_q_name string

resource serverfarms_planvwrvnc_q_name_resource 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: serverfarms_planvwrvnc_q_name
  location: 'Sweden Central'
  sku: {
    name: 'B1'
    tier: 'Basic'
    size: 'B1'
    family: 'B'
    capacity: 1
  }
  kind: 'linux'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    freeOfferExpirationTime: '2026-09-15T13:23:16.1033333'
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
    asyncScalingEnabled: false
  }
}


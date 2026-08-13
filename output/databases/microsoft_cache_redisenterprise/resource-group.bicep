@secure()
param redisEnterprise_redisentmb0uqeyd_publicNetworkAccess string
param redisEnterprise_redisentmb0uqeyd_name string

resource redisEnterprise_redisentmb0uqeyd_name_resource 'Microsoft.Cache/redisEnterprise@2026-02-01-preview' = {
  name: redisEnterprise_redisentmb0uqeyd_name
  location: 'Norway East'
  sku: {
    name: 'Balanced_B0'
  }
  kind: 'v2'
  identity: {
    type: 'None'
  }
  properties: {
    minimumTlsVersion: '1.2'
    highAvailability: 'Disabled'
    publicNetworkAccess: redisEnterprise_redisentmb0uqeyd_publicNetworkAccess
  }
}


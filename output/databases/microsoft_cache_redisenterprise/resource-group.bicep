@secure()
param redisEnterprise_redisentmvtyn0j0_publicNetworkAccess string
param redisEnterprise_redisentmvtyn0j0_name string

resource redisEnterprise_redisentmvtyn0j0_name_resource 'Microsoft.Cache/redisEnterprise@2026-02-01-preview' = {
  name: redisEnterprise_redisentmvtyn0j0_name
  location: 'West Europe'
  sku: {
    name: 'Balanced_B0'
  }
  kind: 'v2'
  identity: {
    type: 'None'
  }
  properties: {
    minimumTlsVersion: '1.2'
    highAvailability: 'Enabled'
    publicNetworkAccess: redisEnterprise_redisentmvtyn0j0_publicNetworkAccess
  }
}


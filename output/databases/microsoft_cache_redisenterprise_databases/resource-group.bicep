@secure()
param redisEnterprise_redisent61yjsz2q_publicNetworkAccess string
param redisEnterprise_redisent61yjsz2q_name string

resource redisEnterprise_redisent61yjsz2q_name_resource 'Microsoft.Cache/redisEnterprise@2026-02-01-preview' = {
  name: redisEnterprise_redisent61yjsz2q_name
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
    publicNetworkAccess: redisEnterprise_redisent61yjsz2q_publicNetworkAccess
  }
}

resource redisEnterprise_redisent61yjsz2q_name_default 'Microsoft.Cache/redisEnterprise/databases@2026-02-01-preview' = {
  parent: redisEnterprise_redisent61yjsz2q_name_resource
  name: 'default'
  properties: {
    clientProtocol: 'Encrypted'
    port: 10000
    clusteringPolicy: 'OSSCluster'
    evictionPolicy: 'VolatileLRU'
    deferUpgrade: 'NotDeferred'
    accessKeysAuthentication: 'Enabled'
  }
}


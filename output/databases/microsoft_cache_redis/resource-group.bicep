param Redis_redisziu0dj94_name string

resource Redis_redisziu0dj94_name_resource 'Microsoft.Cache/Redis@2025-08-01-preview' = {
  name: Redis_redisziu0dj94_name
  location: 'West Europe'
  properties: {
    redisVersion: '6.0'
    sku: {
      name: 'Basic'
      family: 'C'
      capacity: 0
    }
    enableNonSslPort: false
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    redisConfiguration: {
      maxclients: '256'
      'maxmemory-reserved': '30'
      'maxfragmentationmemory-reserved': '30'
      'maxmemory-delta': '30'
    }
    updateChannel: 'Stable'
    disableAccessKeyAuthentication: false
  }
}

resource Redis_redisziu0dj94_name_Data_Contributor 'Microsoft.Cache/Redis/accessPolicies@2025-08-01-preview' = {
  parent: Redis_redisziu0dj94_name_resource
  name: 'Data Contributor'
  properties: {
    permissions: '+@all -@dangerous +cluster|info +cluster|nodes +cluster|slots allkeys'
  }
}

resource Redis_redisziu0dj94_name_Data_Owner 'Microsoft.Cache/Redis/accessPolicies@2025-08-01-preview' = {
  parent: Redis_redisziu0dj94_name_resource
  name: 'Data Owner'
  properties: {
    permissions: '+@all allkeys'
  }
}

resource Redis_redisziu0dj94_name_Data_Reader 'Microsoft.Cache/Redis/accessPolicies@2025-08-01-preview' = {
  parent: Redis_redisziu0dj94_name_resource
  name: 'Data Reader'
  properties: {
    permissions: '+@read +@connection +cluster|info +cluster|nodes +cluster|slots allkeys'
  }
}


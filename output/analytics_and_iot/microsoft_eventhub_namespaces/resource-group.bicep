param namespaces_ehnsw2y13x4d_name string

resource namespaces_ehnsw2y13x4d_name_resource 'Microsoft.EventHub/namespaces@2026-01-01' = {
  name: namespaces_ehnsw2y13x4d_name
  location: 'norwayeast'
  sku: {
    name: 'Basic'
    tier: 'Basic'
    capacity: 1
  }
  properties: {
    platformCapabilities: {
      confidentialCompute: {
        mode: 'Disabled'
      }
    }
    geoDataReplication: {
      maxReplicationLagDurationInSeconds: 0
      locations: [
        {
          locationName: 'norwayeast'
          roleType: 'Primary'
        }
      ]
    }
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    zoneRedundant: true
    isAutoInflateEnabled: false
    maximumThroughputUnits: 0
    kafkaEnabled: true
  }
}

resource namespaces_ehnsw2y13x4d_name_RootManageSharedAccessKey 'Microsoft.EventHub/namespaces/authorizationrules@2026-01-01' = {
  parent: namespaces_ehnsw2y13x4d_name_resource
  name: 'RootManageSharedAccessKey'
  location: 'norwayeast'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

resource namespaces_ehnsw2y13x4d_name_default 'Microsoft.EventHub/namespaces/networkrulesets@2026-01-01' = {
  parent: namespaces_ehnsw2y13x4d_name_resource
  name: 'default'
  location: 'norwayeast'
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Allow'
    virtualNetworkRules: []
    ipRules: []
    trustedServiceAccessEnabled: false
  }
}


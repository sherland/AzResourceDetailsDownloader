param namespaces_sbalnbuxtr_name string

resource namespaces_sbalnbuxtr_name_resource 'Microsoft.ServiceBus/namespaces@2026-01-01' = {
  name: namespaces_sbalnbuxtr_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Standard'
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
    premiumMessagingPartitions: 0
    minimumTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    zoneRedundant: true
  }
}

resource namespaces_sbalnbuxtr_name_RootManageSharedAccessKey 'Microsoft.ServiceBus/namespaces/authorizationrules@2026-01-01' = {
  parent: namespaces_sbalnbuxtr_name_resource
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

resource namespaces_sbalnbuxtr_name_default 'Microsoft.ServiceBus/namespaces/networkrulesets@2026-01-01' = {
  parent: namespaces_sbalnbuxtr_name_resource
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

resource namespaces_sbalnbuxtr_name_topicv0fcfy 'Microsoft.ServiceBus/namespaces/topics@2026-01-01' = {
  parent: namespaces_sbalnbuxtr_name_resource
  name: 'topicv0fcfy'
  location: 'norwayeast'
  properties: {
    maxMessageSizeInKilobytes: 256
    defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    enableBatchedOperations: true
    status: 'Active'
    supportOrdering: true
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}


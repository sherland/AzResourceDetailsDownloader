param namespaces_sbookpd3_f_name string

resource namespaces_sbookpd3_f_name_resource 'Microsoft.ServiceBus/namespaces@2026-01-01' = {
  name: namespaces_sbookpd3_f_name
  location: 'norwayeast'
  sku: {
    name: 'Basic'
    tier: 'Basic'
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

resource namespaces_sbookpd3_f_name_RootManageSharedAccessKey 'Microsoft.ServiceBus/namespaces/authorizationrules@2026-01-01' = {
  parent: namespaces_sbookpd3_f_name_resource
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

resource namespaces_sbookpd3_f_name_default 'Microsoft.ServiceBus/namespaces/networkrulesets@2026-01-01' = {
  parent: namespaces_sbookpd3_f_name_resource
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

resource namespaces_sbookpd3_f_name_queuee2e7_c 'Microsoft.ServiceBus/namespaces/queues@2026-01-01' = {
  parent: namespaces_sbookpd3_f_name_resource
  name: 'queuee2e7-c'
  location: 'norwayeast'
  properties: {
    maxMessageSizeInKilobytes: 256
    lockDuration: 'PT1M'
    maxSizeInMegabytes: 1024
    requiresDuplicateDetection: false
    requiresSession: false
    defaultMessageTimeToLive: 'P14D'
    deadLetteringOnMessageExpiration: false
    enableBatchedOperations: true
    duplicateDetectionHistoryTimeWindow: 'PT10M'
    maxDeliveryCount: 10
    status: 'Active'
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
    enablePartitioning: false
    enableExpress: false
  }
}


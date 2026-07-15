param namespaces_sbg0yna0pz_name string

resource namespaces_sbg0yna0pz_name_resource 'Microsoft.ServiceBus/namespaces@2026-01-01' = {
  name: namespaces_sbg0yna0pz_name
  location: 'westeurope'
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
          locationName: 'westeurope'
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

resource namespaces_sbg0yna0pz_name_RootManageSharedAccessKey 'Microsoft.ServiceBus/namespaces/authorizationrules@2026-01-01' = {
  parent: namespaces_sbg0yna0pz_name_resource
  name: 'RootManageSharedAccessKey'
  location: 'westeurope'
  properties: {
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
}

resource namespaces_sbg0yna0pz_name_default 'Microsoft.ServiceBus/namespaces/networkrulesets@2026-01-01' = {
  parent: namespaces_sbg0yna0pz_name_resource
  name: 'default'
  location: 'westeurope'
  properties: {
    publicNetworkAccess: 'Enabled'
    defaultAction: 'Allow'
    virtualNetworkRules: []
    ipRules: []
    trustedServiceAccessEnabled: false
  }
}

resource namespaces_sbg0yna0pz_name_topicvj_o3e 'Microsoft.ServiceBus/namespaces/topics@2026-01-01' = {
  parent: namespaces_sbg0yna0pz_name_resource
  name: 'topicvj-o3e'
  location: 'westeurope'
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

resource namespaces_sbg0yna0pz_name_topicvj_o3e_subuea0ba 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2026-01-01' = {
  parent: namespaces_sbg0yna0pz_name_topicvj_o3e
  name: 'subuea0ba'
  location: 'westeurope'
  properties: {
    isClientAffine: false
    lockDuration: 'PT1M'
    requiresSession: false
    defaultMessageTimeToLive: 'P10675199DT2H48M5.4775807S'
    deadLetteringOnMessageExpiration: false
    deadLetteringOnFilterEvaluationExceptions: true
    maxDeliveryCount: 10
    status: 'Active'
    enableBatchedOperations: true
    autoDeleteOnIdle: 'P10675199DT2H48M5.4775807S'
  }
  dependsOn: [
    namespaces_sbg0yna0pz_name_resource
  ]
}

resource namespaces_sbg0yna0pz_name_topicvj_o3e_subuea0ba_Default 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2026-01-01' = {
  parent: namespaces_sbg0yna0pz_name_topicvj_o3e_subuea0ba
  name: '$Default'
  location: 'westeurope'
  properties: {
    action: {}
    filterType: 'SqlFilter'
    sqlFilter: {
      sqlExpression: '1=1'
      compatibilityLevel: 20
    }
  }
  dependsOn: [
    namespaces_sbg0yna0pz_name_topicvj_o3e
    namespaces_sbg0yna0pz_name_resource
  ]
}


param namespaces_ehns2z7d7gyo_name string

resource namespaces_ehns2z7d7gyo_name_resource 'Microsoft.EventHub/namespaces@2026-01-01' = {
  name: namespaces_ehns2z7d7gyo_name
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

resource namespaces_ehns2z7d7gyo_name_RootManageSharedAccessKey 'Microsoft.EventHub/namespaces/authorizationrules@2026-01-01' = {
  parent: namespaces_ehns2z7d7gyo_name_resource
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

resource namespaces_ehns2z7d7gyo_name_ehu6z_fa 'Microsoft.EventHub/namespaces/eventhubs@2026-01-01' = {
  parent: namespaces_ehns2z7d7gyo_name_resource
  name: 'ehu6z-fa'
  location: 'norwayeast'
  properties: {
    messageTimestampDescription: {
      timestampType: 'LogAppend'
    }
    retentionDescription: {
      cleanupPolicy: 'Delete'
      retentionTimeInHours: 24
    }
    messageRetentionInDays: 1
    partitionCount: 1
    status: 'Active'
  }
}

resource namespaces_ehns2z7d7gyo_name_default 'Microsoft.EventHub/namespaces/networkrulesets@2026-01-01' = {
  parent: namespaces_ehns2z7d7gyo_name_resource
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

resource namespaces_ehns2z7d7gyo_name_ehu6z_fa_Default 'Microsoft.EventHub/namespaces/eventhubs/consumergroups@2026-01-01' = {
  parent: namespaces_ehns2z7d7gyo_name_ehu6z_fa
  name: '$Default'
  location: 'norwayeast'
  properties: {}
  dependsOn: [
    namespaces_ehns2z7d7gyo_name_resource
  ]
}


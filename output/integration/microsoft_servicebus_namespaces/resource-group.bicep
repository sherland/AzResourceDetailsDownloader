param namespaces_sb4hb2w_dr_name string

resource namespaces_sb4hb2w_dr_name_resource 'Microsoft.ServiceBus/namespaces@2026-01-01' = {
  name: namespaces_sb4hb2w_dr_name
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

resource namespaces_sb4hb2w_dr_name_RootManageSharedAccessKey 'Microsoft.ServiceBus/namespaces/authorizationrules@2026-01-01' = {
  parent: namespaces_sb4hb2w_dr_name_resource
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

resource namespaces_sb4hb2w_dr_name_default 'Microsoft.ServiceBus/namespaces/networkrulesets@2026-01-01' = {
  parent: namespaces_sb4hb2w_dr_name_resource
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


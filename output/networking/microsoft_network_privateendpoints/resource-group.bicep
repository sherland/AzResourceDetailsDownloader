param storageAccounts_stgrpess3j_name string
param privateEndpoints_pe04_kvqau_name string
param virtualNetworks_vnet0h2lk99r_name string

resource virtualNetworks_vnet0h2lk99r_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet0h2lk99r_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.42.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnet0h2lk99r_name_default.id
        properties: {
          addressPrefix: '10.42.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource storageAccounts_stgrpess3j_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_stgrpess3j_name
  location: 'norwayeast'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      ipv6Rules: []
      bypass: 'None'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource virtualNetworks_vnet0h2lk99r_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet0h2lk99r_name}/default'
  properties: {
    addressPrefix: '10.42.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet0h2lk99r_name_resource
  ]
}

resource storageAccounts_stgrpess3j_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_stgrpess3j_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_stgrpess3j_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_stgrpess3j_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_stgrpess3j_name_storageAccounts_stgrpess3j_name_69e6d29b_f201_45d6_b5f0_a4403d496671 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-04-01' = {
  parent: storageAccounts_stgrpess3j_name_resource
  name: '${storageAccounts_stgrpess3j_name}.69e6d29b-f201-45d6-b5f0-a4403d496671'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_stgrpess3j_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_stgrpess3j_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_stgrpess3j_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_stgrpess3j_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource privateEndpoints_pe04_kvqau_name_resource 'Microsoft.Network/privateEndpoints@2025-07-01' = {
  name: privateEndpoints_pe04_kvqau_name
  location: 'norwayeast'
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'peconn1'
        id: '${privateEndpoints_pe04_kvqau_name_resource.id}/privateLinkServiceConnections/peconn1'
        properties: {
          privateLinkServiceId: storageAccounts_stgrpess3j_name_resource.id
          groupIds: [
            'blob'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_vnet0h2lk99r_name_default.id
    }
    ipConfigurations: []
    customDnsConfigs: [
      {
        fqdn: 'stgrpess3j.blob.core.windows.net'
        ipAddresses: [
          '10.42.0.4'
        ]
      }
    ]
    ipVersionType: 'IPv4'
  }
}


param storageAccounts_st9crnw0b9_name string
param privateEndpoints_penzc8co_v_name string
param virtualNetworks_vnet70_8j52w_name string

resource virtualNetworks_vnet70_8j52w_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet70_8j52w_name
  location: 'westeurope'
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
        id: virtualNetworks_vnet70_8j52w_name_default.id
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

resource storageAccounts_st9crnw0b9_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_st9crnw0b9_name
  location: 'westeurope'
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

resource virtualNetworks_vnet70_8j52w_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet70_8j52w_name}/default'
  properties: {
    addressPrefix: '10.42.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet70_8j52w_name_resource
  ]
}

resource storageAccounts_st9crnw0b9_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_st9crnw0b9_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_st9crnw0b9_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_st9crnw0b9_name_resource
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

resource storageAccounts_st9crnw0b9_name_storageAccounts_st9crnw0b9_name_d5fd1759_e3ca_4c6b_9890_18a76a4e423d 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-04-01' = {
  parent: storageAccounts_st9crnw0b9_name_resource
  name: '${storageAccounts_st9crnw0b9_name}.d5fd1759-e3ca-4c6b-9890-18a76a4e423d'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_st9crnw0b9_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_st9crnw0b9_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_st9crnw0b9_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_st9crnw0b9_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource privateEndpoints_penzc8co_v_name_resource 'Microsoft.Network/privateEndpoints@2025-07-01' = {
  name: privateEndpoints_penzc8co_v_name
  location: 'westeurope'
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'peconn1'
        id: '${privateEndpoints_penzc8co_v_name_resource.id}/privateLinkServiceConnections/peconn1'
        properties: {
          privateLinkServiceId: storageAccounts_st9crnw0b9_name_resource.id
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
      id: virtualNetworks_vnet70_8j52w_name_default.id
    }
    ipConfigurations: []
    customDnsConfigs: [
      {
        fqdn: 'st9crnw0b9.blob.core.windows.net'
        ipAddresses: [
          '10.42.0.4'
        ]
      }
    ]
    ipVersionType: 'IPv4'
  }
}


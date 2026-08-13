param storageAccounts_stzbwkrmnn_name string
param privateEndpoints_peavc8p_9p_name string
param virtualNetworks_vnetari4_k_l_name string

resource virtualNetworks_vnetari4_k_l_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetari4_k_l_name
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
        id: virtualNetworks_vnetari4_k_l_name_default.id
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

resource storageAccounts_stzbwkrmnn_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_stzbwkrmnn_name
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

resource virtualNetworks_vnetari4_k_l_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetari4_k_l_name}/default'
  properties: {
    addressPrefix: '10.42.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetari4_k_l_name_resource
  ]
}

resource storageAccounts_stzbwkrmnn_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_stzbwkrmnn_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_stzbwkrmnn_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_stzbwkrmnn_name_resource
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

resource storageAccounts_stzbwkrmnn_name_storageAccounts_stzbwkrmnn_name_f4504f54_49d3_47c3_95c2_abe1ed8fe779 'Microsoft.Storage/storageAccounts/privateEndpointConnections@2026-04-01' = {
  parent: storageAccounts_stzbwkrmnn_name_resource
  name: '${storageAccounts_stzbwkrmnn_name}.f4504f54-49d3-47c3-95c2-abe1ed8fe779'
  properties: {
    privateEndpoint: {}
    privateLinkServiceConnectionState: {
      status: 'Approved'
      description: 'Auto-Approved'
      actionRequired: 'None'
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_stzbwkrmnn_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_stzbwkrmnn_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_stzbwkrmnn_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_stzbwkrmnn_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource privateEndpoints_peavc8p_9p_name_resource 'Microsoft.Network/privateEndpoints@2025-07-01' = {
  name: privateEndpoints_peavc8p_9p_name
  location: 'norwayeast'
  properties: {
    privateLinkServiceConnections: [
      {
        name: 'peconn1'
        id: '${privateEndpoints_peavc8p_9p_name_resource.id}/privateLinkServiceConnections/peconn1'
        properties: {
          privateLinkServiceId: storageAccounts_stzbwkrmnn_name_resource.id
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
      id: virtualNetworks_vnetari4_k_l_name_default.id
    }
    ipConfigurations: []
    customDnsConfigs: [
      {
        fqdn: 'stzbwkrmnn.blob.core.windows.net'
        ipAddresses: [
          '10.42.0.4'
        ]
      }
    ]
    ipVersionType: 'IPv4'
  }
}


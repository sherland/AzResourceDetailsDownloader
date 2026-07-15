param accounts_avijmur3g6t_name string
param storageAccounts_st32wnmsmg_name string

resource storageAccounts_st32wnmsmg_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_st32wnmsmg_name
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

resource storageAccounts_st32wnmsmg_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_st32wnmsmg_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_st32wnmsmg_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_st32wnmsmg_name_resource
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

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_st32wnmsmg_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_st32wnmsmg_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_st32wnmsmg_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_st32wnmsmg_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource accounts_avijmur3g6t_name_resource 'Microsoft.VideoIndexer/accounts@2025-04-01' = {
  name: accounts_avijmur3g6t_name
  location: 'westeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accountId: 'a4009794-5e2c-4ee2-b74d-87e296d62e8d'
    storageServices: {
      resourceId: storageAccounts_st32wnmsmg_name_resource.id
    }
  }
}


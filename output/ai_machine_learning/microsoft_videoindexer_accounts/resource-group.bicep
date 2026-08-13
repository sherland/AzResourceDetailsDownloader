param accounts_avin3f5p_m4_name string
param storageAccounts_stuop4pbp3_name string

resource storageAccounts_stuop4pbp3_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_stuop4pbp3_name
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

resource storageAccounts_stuop4pbp3_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_stuop4pbp3_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_stuop4pbp3_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_stuop4pbp3_name_resource
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

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_stuop4pbp3_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_stuop4pbp3_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_stuop4pbp3_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_stuop4pbp3_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource accounts_avin3f5p_m4_name_resource 'Microsoft.VideoIndexer/accounts@2025-04-01' = {
  name: accounts_avin3f5p_m4_name
  location: 'swedencentral'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    accountId: '19bb8ba2-9efd-44fb-abee-c7960652eb61'
    storageServices: {
      resourceId: storageAccounts_stuop4pbp3_name_resource.id
    }
  }
}


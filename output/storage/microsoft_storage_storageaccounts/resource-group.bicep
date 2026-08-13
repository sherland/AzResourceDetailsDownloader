param storageAccounts_st79pr3my4_name string

resource storageAccounts_st79pr3my4_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_st79pr3my4_name
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

resource storageAccounts_st79pr3my4_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_st79pr3my4_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_st79pr3my4_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_st79pr3my4_name_resource
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

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_st79pr3my4_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_st79pr3my4_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_st79pr3my4_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_st79pr3my4_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}


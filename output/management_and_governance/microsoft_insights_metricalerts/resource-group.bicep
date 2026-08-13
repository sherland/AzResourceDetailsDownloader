param metricAlerts_ma1gb7eym1_name string
param storageAccounts_st5rlbh116_name string

resource storageAccounts_st5rlbh116_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_st5rlbh116_name
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

resource metricAlerts_ma1gb7eym1_name_resource 'Microsoft.Insights/metricAlerts@2024-03-01-preview' = {
  name: metricAlerts_ma1gb7eym1_name
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      storageAccounts_st5rlbh116_name_resource.id
    ]
    evaluationFrequency: 'PT5M'
    actions: []
    windowSize: 'PT15M'
    criteria: {
      allOf: [
        {
          operator: 'GreaterThan'
          threshold: json('1000000')
          name: 'cond1'
          metricName: 'Transactions'
          dimensions: []
          timeAggregation: 'Total'
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
  }
}

resource storageAccounts_st5rlbh116_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_st5rlbh116_name_resource
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

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_st5rlbh116_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_st5rlbh116_name_resource
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

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_st5rlbh116_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_st5rlbh116_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_st5rlbh116_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_st5rlbh116_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}


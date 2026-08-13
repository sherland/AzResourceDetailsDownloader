param backupVaults_bvaultoviytzop_name string

resource backupVaults_bvaultoviytzop_name_resource 'Microsoft.DataProtection/backupVaults@2026-04-01-preview' = {
  name: backupVaults_bvaultoviytzop_name
  location: 'norwayeast'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    storageSettings: [
      {
        datastoreType: 'VaultStore'
        type: 'LocallyRedundant'
      }
    ]
    securitySettings: {
      softDeleteSettings: {
        state: 'On'
        retentionDurationInDays: json('14')
      }
    }
    replicatedRegions: []
  }
}

resource backupVaults_bvaultoviytzop_name_policyb8_t_9 'Microsoft.DataProtection/backupVaults/backupPolicies@2026-04-01-preview' = {
  parent: backupVaults_bvaultoviytzop_name_resource
  name: 'policyb8-t-9'
  properties: {
    policyRules: [
      {
        lifecycles: [
          {
            deleteAfter: {
              objectType: 'AbsoluteDeleteOption'
              duration: 'P7D'
            }
            sourceDataStore: {
              dataStoreType: 'OperationalStore'
              objectType: 'DataStoreInfoBase'
            }
          }
        ]
        isDefault: true
        name: 'Default'
        objectType: 'AzureRetentionRule'
      }
    ]
    datasourceTypes: [
      'Microsoft.Storage/storageAccounts/blobServices'
    ]
    objectType: 'BackupPolicy'
  }
}


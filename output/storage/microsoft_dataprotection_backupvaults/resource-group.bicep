param backupVaults_bvaulths4wux85_name string

resource backupVaults_bvaulths4wux85_name_resource 'Microsoft.DataProtection/backupVaults@2026-04-01-preview' = {
  name: backupVaults_bvaulths4wux85_name
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


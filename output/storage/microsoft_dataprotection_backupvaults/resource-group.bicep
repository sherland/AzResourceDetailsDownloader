param backupVaults_bvault6hxu_8r7_name string

resource backupVaults_bvault6hxu_8r7_name_resource 'Microsoft.DataProtection/backupVaults@2026-04-01-preview' = {
  name: backupVaults_bvault6hxu_8r7_name
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


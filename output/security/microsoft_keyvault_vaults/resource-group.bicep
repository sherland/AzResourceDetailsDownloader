param vaults_kv68u_db_c_name string

resource vaults_kv68u_db_c_name_resource 'Microsoft.KeyVault/vaults@2026-03-01-preview' = {
  name: vaults_kv68u_db_c_name
  location: 'norwayeast'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: '11111111-1111-1111-1111-111111111111'
    accessPolicies: []
    enabledForDeployment: false
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    enableRbacAuthorization: true
    enablePurgeProtection: true
    vaultUri: 'https://${vaults_kv68u_db_c_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}


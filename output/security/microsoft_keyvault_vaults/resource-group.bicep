param vaults_kv8_9k4hh9_name string

resource vaults_kv8_9k4hh9_name_resource 'Microsoft.KeyVault/vaults@2026-03-01-preview' = {
  name: vaults_kv8_9k4hh9_name
  location: 'westeurope'
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
    vaultUri: 'https://${vaults_kv8_9k4hh9_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}


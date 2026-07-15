param vaults_kvr0fb_t_v_name string

resource vaults_kvr0fb_t_v_name_resource 'Microsoft.KeyVault/vaults@2026-03-01-preview' = {
  name: vaults_kvr0fb_t_v_name
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
    vaultUri: 'https://${vaults_kvr0fb_t_v_name}.vault.azure.net/'
    provisioningState: 'Succeeded'
    publicNetworkAccess: 'Enabled'
  }
}


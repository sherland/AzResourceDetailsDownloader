param batchAccounts_batchp09vx5pt_name string

resource batchAccounts_batchp09vx5pt_name_resource 'Microsoft.Batch/batchAccounts@2025-06-01' = {
  name: batchAccounts_batchp09vx5pt_name
  location: 'westeurope'
  identity: {
    type: 'None'
  }
  properties: {
    poolAllocationMode: 'BatchService'
    publicNetworkAccess: 'Enabled'
    encryption: {
      keySource: 'Microsoft.Batch'
    }
    allowedAuthenticationModes: [
      'SharedKey'
      'AAD'
      'TaskAuthenticationToken'
    ]
  }
}


param resourceGuards_guardd9o3_acn_name string

resource resourceGuards_guardd9o3_acn_name_resource 'Microsoft.DataProtection/resourceGuards@2026-04-01-preview' = {
  name: resourceGuards_guardd9o3_acn_name
  location: 'westeurope'
  properties: {
    vaultCriticalOperationExclusionList: []
  }
}


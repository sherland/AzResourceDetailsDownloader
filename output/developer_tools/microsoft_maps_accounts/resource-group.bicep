param accounts_mapsd_2raxh4_name string

resource accounts_mapsd_2raxh4_name_resource 'Microsoft.Maps/accounts@2025-10-01-preview' = {
  name: accounts_mapsd_2raxh4_name
  location: 'global'
  sku: {
    name: 'G2'
    tier: 'Standard'
  }
  kind: 'Gen2'
  properties: {
    disableLocalAuth: false
    publicNetworkAccess: 'enabled'
    locations: []
  }
}


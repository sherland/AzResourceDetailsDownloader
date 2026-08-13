param accounts_amona_g_1_e5_name string

resource accounts_amona_g_1_e5_name_resource 'microsoft.monitor/accounts@2025-10-03-preview' = {
  name: accounts_amona_g_1_e5_name
  location: 'norwayeast'
  properties: {
    publicNetworkAccess: 'Enabled'
  }
}


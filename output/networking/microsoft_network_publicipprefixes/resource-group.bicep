param publicIPPrefixes_pippfxwtr6ge_name string

resource publicIPPrefixes_pippfxwtr6ge_name_resource 'Microsoft.Network/publicIPPrefixes@2025-07-01' = {
  name: publicIPPrefixes_pippfxwtr6ge_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    prefixLength: 28
    publicIPAddressVersion: 'IPv4'
    ipTags: []
  }
}


param dnsResolvers_dnsr1f3k6j_x_name string
param virtualNetworks_vnetkh0jx_02_name string

resource virtualNetworks_vnetkh0jx_02_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetkh0jx_02_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.61.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: []
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource dnsResolvers_dnsr1f3k6j_x_name_resource 'Microsoft.Network/dnsResolvers@2025-10-01-preview' = {
  name: dnsResolvers_dnsr1f3k6j_x_name
  location: 'norwayeast'
  properties: {
    virtualNetwork: {
      id: virtualNetworks_vnetkh0jx_02_name_resource.id
    }
  }
}


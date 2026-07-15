param virtualNetworks_vnetazg63ied_name string

resource virtualNetworks_vnetazg63ied_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetazg63ied_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: []
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}


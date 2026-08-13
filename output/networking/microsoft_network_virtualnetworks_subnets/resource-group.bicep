param virtualNetworks_vnet93wy8s69_name string

resource virtualNetworks_vnet93wy8s69_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet93wy8s69_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.10.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'subnetcua-vp'
        id: virtualNetworks_vnet93wy8s69_name_subnetcua_vp.id
        properties: {
          addressPrefix: '10.10.1.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet93wy8s69_name_subnetcua_vp 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet93wy8s69_name}/subnetcua-vp'
  properties: {
    addressPrefix: '10.10.1.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet93wy8s69_name_resource
  ]
}


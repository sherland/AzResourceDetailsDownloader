param virtualNetworks_vnetu_a_at4d_name string
param networkInterfaces_nicoq4tq3cl_name string

resource virtualNetworks_vnetu_a_at4d_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetu_a_at4d_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.41.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnetu_a_at4d_name_default.id
        properties: {
          addressPrefix: '10.41.0.0/24'
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

resource networkInterfaces_nicoq4tq3cl_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_nicoq4tq3cl_name
  location: 'westeurope'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_nicoq4tq3cl_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.41.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnetu_a_at4d_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource virtualNetworks_vnetu_a_at4d_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetu_a_at4d_name}/default'
  properties: {
    addressPrefix: '10.41.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetu_a_at4d_name_resource
  ]
}


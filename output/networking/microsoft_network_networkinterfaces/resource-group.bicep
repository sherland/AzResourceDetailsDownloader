param virtualNetworks_vnet6w9u_4z7_name string
param networkInterfaces_nict1tfp2zk_name string

resource virtualNetworks_vnet6w9u_4z7_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet6w9u_4z7_name
  location: 'norwayeast'
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
        id: virtualNetworks_vnet6w9u_4z7_name_default.id
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

resource networkInterfaces_nict1tfp2zk_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_nict1tfp2zk_name
  location: 'norwayeast'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_nict1tfp2zk_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.41.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet6w9u_4z7_name_default.id
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

resource virtualNetworks_vnet6w9u_4z7_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet6w9u_4z7_name}/default'
  properties: {
    addressPrefix: '10.41.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet6w9u_4z7_name_resource
  ]
}


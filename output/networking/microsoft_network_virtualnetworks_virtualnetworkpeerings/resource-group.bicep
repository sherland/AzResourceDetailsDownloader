param virtualNetworks_vnet5nvk_1_n_name string
param virtualNetworks_vneteeas9wos_name string

resource virtualNetworks_vneteeas9wos_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vneteeas9wos_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.91.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: []
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet5nvk_1_n_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet5nvk_1_n_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.90.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: []
    virtualNetworkPeerings: [
      {
        name: 'peer-to-b'
        id: virtualNetworks_vnet5nvk_1_n_name_peer_to_b.id
        properties: {
          peeringState: 'Initiated'
          peeringSyncLevel: 'RemoteNotInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vneteeas9wos_name_resource.id
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          remoteAddressSpace: {
            addressPrefixes: [
              '10.91.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.91.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet5nvk_1_n_name_peer_to_b 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  name: '${virtualNetworks_vnet5nvk_1_n_name}/peer-to-b'
  properties: {
    peeringState: 'Initiated'
    peeringSyncLevel: 'RemoteNotInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vneteeas9wos_name_resource.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.91.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.91.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet5nvk_1_n_name_resource
  ]
}


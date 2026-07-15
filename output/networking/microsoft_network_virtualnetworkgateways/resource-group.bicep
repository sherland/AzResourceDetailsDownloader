param virtualNetworks_vnetj03y6p07_name string
param publicIPAddresses_pipn1pda_f4_name string
param virtualNetworkGateways_vgwhk9b25pp_name string

resource publicIPAddresses_pipn1pda_f4_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pipn1pda_f4_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
    '2'
    '3'
  ]
  properties: {
    ipAddress: '20.8.26.208'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnetj03y6p07_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetj03y6p07_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_vnetj03y6p07_name_GatewaySubnet.id
        properties: {
          addressPrefix: '10.20.255.0/27'
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

resource virtualNetworks_vnetj03y6p07_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetj03y6p07_name}/GatewaySubnet'
  properties: {
    addressPrefix: '10.20.255.0/27'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetj03y6p07_name_resource
  ]
}

resource virtualNetworkGateways_vgwhk9b25pp_name_resource 'Microsoft.Network/virtualNetworkGateways@2025-07-01' = {
  name: virtualNetworkGateways_vgwhk9b25pp_name
  location: 'westeurope'
  properties: {
    enablePrivateIpAddress: false
    virtualNetworkGatewayMigrationStatus: {
      state: 'None'
      phase: 'None'
    }
    ipConfigurations: [
      {
        name: 'vnetGatewayConfig'
        id: '${virtualNetworkGateways_vgwhk9b25pp_name_resource.id}/ipConfigurations/vnetGatewayConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pipn1pda_f4_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnetj03y6p07_name_GatewaySubnet.id
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw1AZ'
      tier: 'VpnGw1AZ'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    enableHighBandwidthVpnGateway: false
    activeActive: false
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.20.255.30'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_vgwhk9b25pp_name_resource.id}/ipConfigurations/vnetGatewayConfig'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}


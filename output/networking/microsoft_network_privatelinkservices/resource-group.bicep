param loadBalancers_lbv3r8rnuu_name string
param virtualNetworks_vnet3rh8yq8u_name string
param privateLinkServices_plsd0_7_olm_name string
param networkInterfaces_plsd0_7_olm_nic_14af038b_c51c_45d4_8d88_379c95678db3_name string

resource virtualNetworks_vnet3rh8yq8u_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet3rh8yq8u_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.64.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnet3rh8yq8u_name_default.id
        properties: {
          addressPrefix: '10.64.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource loadBalancers_lbv3r8rnuu_name_resource 'Microsoft.Network/loadBalancers@2025-07-01' = {
  name: loadBalancers_lbv3r8rnuu_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'feConfig'
        id: '${loadBalancers_lbv3r8rnuu_name_resource.id}/frontendIPConfigurations/feConfig'
        properties: {
          privateIPAddress: '10.64.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet3rh8yq8u_name_default.id
          }
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    backendAddressPools: []
    loadBalancingRules: []
    probes: []
    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
}

resource virtualNetworks_vnet3rh8yq8u_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet3rh8yq8u_name}/default'
  properties: {
    addressPrefix: '10.64.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
  dependsOn: [
    virtualNetworks_vnet3rh8yq8u_name_resource
  ]
}

resource networkInterfaces_plsd0_7_olm_nic_14af038b_c51c_45d4_8d88_379c95678db3_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_plsd0_7_olm_nic_14af038b_c51c_45d4_8d88_379c95678db3_name
  location: 'norwayeast'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'plsipconfig'
        id: '${networkInterfaces_plsd0_7_olm_nic_14af038b_c51c_45d4_8d88_379c95678db3_name_resource.id}/ipConfigurations/plsipconfig'
        properties: {
          privateIPAddress: '10.64.0.5'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet3rh8yq8u_name_default.id
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
    privateLinkService: {
      id: privateLinkServices_plsd0_7_olm_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource privateLinkServices_plsd0_7_olm_name_resource 'Microsoft.Network/privateLinkServices@2025-07-01' = {
  name: privateLinkServices_plsd0_7_olm_name
  location: 'norwayeast'
  properties: {
    fqdns: []
    accessMode: 'Default'
    enableProxyProtocol: false
    loadBalancerFrontendIpConfigurations: [
      {
        id: '${loadBalancers_lbv3r8rnuu_name_resource.id}/frontendIPConfigurations/feConfig'
      }
    ]
    ipConfigurations: [
      {
        name: 'plsipconfig'
        id: '${privateLinkServices_plsd0_7_olm_name_resource.id}/ipConfigurations/plsipconfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet3rh8yq8u_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
  }
}


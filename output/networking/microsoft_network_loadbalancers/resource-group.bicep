param loadBalancers_lbg0_euchu_name string
param publicIPAddresses_pip48sal3_5_name string

resource publicIPAddresses_pip48sal3_5_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pip48sal3_5_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.251.57.52'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource loadBalancers_lbg0_euchu_name_resource 'Microsoft.Network/loadBalancers@2025-07-01' = {
  name: loadBalancers_lbg0_euchu_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'feConfig'
        id: '${loadBalancers_lbg0_euchu_name_resource.id}/frontendIPConfigurations/feConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pip48sal3_5_name_resource.id
          }
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


param loadBalancers_lb7y7v6_8y_name string
param publicIPAddresses_pipjc_fv_7p_name string

resource publicIPAddresses_pipjc_fv_7p_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pipjc_fv_7p_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '4.235.102.66'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource loadBalancers_lb7y7v6_8y_name_resource 'Microsoft.Network/loadBalancers@2025-07-01' = {
  name: loadBalancers_lb7y7v6_8y_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'feConfig'
        id: '${loadBalancers_lb7y7v6_8y_name_resource.id}/frontendIPConfigurations/feConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pipjc_fv_7p_name_resource.id
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


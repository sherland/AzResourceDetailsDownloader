param loadBalancers_lbi1py_djf_name string
param publicIPAddresses_pip4esx_wt9_name string

resource publicIPAddresses_pip4esx_wt9_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pip4esx_wt9_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.224.86.11'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource loadBalancers_lbi1py_djf_name_resource 'Microsoft.Network/loadBalancers@2025-07-01' = {
  name: loadBalancers_lbi1py_djf_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'feConfig'
        id: '${loadBalancers_lbi1py_djf_name_resource.id}/frontendIPConfigurations/feConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pip4esx_wt9_name_resource.id
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


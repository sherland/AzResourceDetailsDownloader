param loadBalancers_lbumojaw4n_name string
param publicIPAddresses_pipw5v3_j40_name string

resource publicIPAddresses_pipw5v3_j40_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pipw5v3_j40_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '51.120.80.174'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource loadBalancers_lbumojaw4n_name_resource 'Microsoft.Network/loadBalancers@2025-07-01' = {
  name: loadBalancers_lbumojaw4n_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: 'feConfig'
        id: '${loadBalancers_lbumojaw4n_name_resource.id}/frontendIPConfigurations/feConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pipw5v3_j40_name_resource.id
          }
        }
      }
    ]
    backendAddressPools: []
    loadBalancingRules: []
    probes: []
    inboundNatRules: [
      {
        name: 'natrulewegbj7'
        id: loadBalancers_lbumojaw4n_name_natrulewegbj7.id
        properties: {
          frontendIPConfiguration: {
            id: '${loadBalancers_lbumojaw4n_name_resource.id}/frontendIPConfigurations/feConfig'
          }
          frontendPort: 5000
          backendPort: 22
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          protocol: 'Tcp'
          enableTcpReset: false
        }
      }
    ]
    outboundRules: []
    inboundNatPools: []
  }
}

resource loadBalancers_lbumojaw4n_name_natrulewegbj7 'Microsoft.Network/loadBalancers/inboundNatRules@2025-07-01' = {
  name: '${loadBalancers_lbumojaw4n_name}/natrulewegbj7'
  properties: {
    frontendIPConfiguration: {
      id: '${loadBalancers_lbumojaw4n_name_resource.id}/frontendIPConfigurations/feConfig'
    }
    frontendPort: 5000
    backendPort: 22
    enableFloatingIP: false
    idleTimeoutInMinutes: 4
    protocol: 'Tcp'
    enableTcpReset: false
  }
}


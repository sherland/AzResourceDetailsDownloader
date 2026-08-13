param natGateways_natatj1p_oe_name string
param publicIPAddresses_pipx9_c_rky_name string

resource natGateways_natatj1p_oe_name_resource 'Microsoft.Network/natGateways@2025-07-01' = {
  name: natGateways_natatj1p_oe_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    idleTimeoutInMinutes: 4
    publicIpAddresses: [
      {
        id: publicIPAddresses_pipx9_c_rky_name_resource.id
      }
    ]
  }
}

resource publicIPAddresses_pipx9_c_rky_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pipx9_c_rky_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    natGateway: {
      id: natGateways_natatj1p_oe_name_resource.id
    }
    ipAddress: '51.120.81.178'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}


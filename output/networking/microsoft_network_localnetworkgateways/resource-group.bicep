param localNetworkGateways_lngrd5p5kd4_name string

resource localNetworkGateways_lngrd5p5kd4_name_resource 'Microsoft.Network/localNetworkGateways@2025-07-01' = {
  name: localNetworkGateways_lngrd5p5kd4_name
  location: 'norwayeast'
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        '192.168.100.0/24'
      ]
    }
    gatewayIpAddress: '203.0.113.1'
  }
}


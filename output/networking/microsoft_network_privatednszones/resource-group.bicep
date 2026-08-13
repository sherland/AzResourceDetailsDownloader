param privateDnsZones_ardlx8xpcur0_private_contoso_com_name string

resource privateDnsZones_ardlx8xpcur0_private_contoso_com_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_ardlx8xpcur0_private_contoso_com_name
  location: 'global'
  properties: {}
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_ardlx8xpcur0_private_contoso_com_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_ardlx8xpcur0_private_contoso_com_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}


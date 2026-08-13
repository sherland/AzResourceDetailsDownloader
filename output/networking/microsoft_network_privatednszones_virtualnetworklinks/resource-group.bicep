param virtualNetworks_vnet0643rlhc_name string
param privateDnsZones_ardlaksrdys9_private_contoso_com_name string

resource privateDnsZones_ardlaksrdys9_private_contoso_com_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_ardlaksrdys9_private_contoso_com_name
  location: 'global'
  properties: {}
}

resource virtualNetworks_vnet0643rlhc_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet0643rlhc_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.43.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: []
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_ardlaksrdys9_private_contoso_com_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_ardlaksrdys9_private_contoso_com_name_resource
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

resource privateDnsZones_ardlaksrdys9_private_contoso_com_name_linkwq5sky 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_ardlaksrdys9_private_contoso_com_name_resource
  name: 'linkwq5sky'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_vnet0643rlhc_name_resource.id
    }
  }
}


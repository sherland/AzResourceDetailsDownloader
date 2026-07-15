param virtualNetworks_vnetqj_7mjap_name string
param privateDnsZones_ardltawm47lo_private_contoso_com_name string

resource privateDnsZones_ardltawm47lo_private_contoso_com_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_ardltawm47lo_private_contoso_com_name
  location: 'global'
  properties: {}
}

resource virtualNetworks_vnetqj_7mjap_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetqj_7mjap_name
  location: 'westeurope'
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

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_ardltawm47lo_private_contoso_com_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_ardltawm47lo_private_contoso_com_name_resource
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

resource privateDnsZones_ardltawm47lo_private_contoso_com_name_linkjqxt8p 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_ardltawm47lo_private_contoso_com_name_resource
  name: 'linkjqxt8p'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_vnetqj_7mjap_name_resource.id
    }
  }
}


param dnsResolvers_dnsrqragsytf_name string
param virtualNetworks_vnet5jlfehrw_name string

resource virtualNetworks_vnet5jlfehrw_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet5jlfehrw_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.63.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'outbound'
        id: virtualNetworks_vnet5jlfehrw_name_outbound.id
        properties: {
          addressPrefix: '10.63.0.0/28'
          delegations: [
            {
              name: 'dnsResolverDelegation'
              id: '${virtualNetworks_vnet5jlfehrw_name_outbound.id}/delegations/dnsResolverDelegation'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
              type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
            }
          ]
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource dnsResolvers_dnsrqragsytf_name_resource 'Microsoft.Network/dnsResolvers@2025-10-01-preview' = {
  name: dnsResolvers_dnsrqragsytf_name
  location: 'norwayeast'
  properties: {
    virtualNetwork: {
      id: virtualNetworks_vnet5jlfehrw_name_resource.id
    }
  }
}

resource virtualNetworks_vnet5jlfehrw_name_outbound 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet5jlfehrw_name}/outbound'
  properties: {
    addressPrefix: '10.63.0.0/28'
    delegations: [
      {
        name: 'dnsResolverDelegation'
        id: '${virtualNetworks_vnet5jlfehrw_name_outbound.id}/delegations/dnsResolverDelegation'
        properties: {
          serviceName: 'Microsoft.Network/dnsResolvers'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets/delegations'
      }
    ]
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet5jlfehrw_name_resource
  ]
}

resource dnsResolvers_dnsrqragsytf_name_outboundngye8c 'Microsoft.Network/dnsResolvers/outboundEndpoints@2025-10-01-preview' = {
  parent: dnsResolvers_dnsrqragsytf_name_resource
  name: 'outboundngye8c'
  location: 'norwayeast'
  properties: {
    subnet: {
      id: virtualNetworks_vnet5jlfehrw_name_outbound.id
    }
  }
}


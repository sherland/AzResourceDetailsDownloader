param dnsResolvers_dnsrb_031p_1_name string
param virtualNetworks_vnet3f_jfiwn_name string

resource virtualNetworks_vnet3f_jfiwn_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet3f_jfiwn_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.62.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'inbound'
        id: virtualNetworks_vnet3f_jfiwn_name_inbound.id
        properties: {
          addressPrefix: '10.62.0.0/28'
          delegations: [
            {
              name: 'dnsResolverDelegation'
              id: '${virtualNetworks_vnet3f_jfiwn_name_inbound.id}/delegations/dnsResolverDelegation'
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

resource dnsResolvers_dnsrb_031p_1_name_resource 'Microsoft.Network/dnsResolvers@2025-10-01-preview' = {
  name: dnsResolvers_dnsrb_031p_1_name
  location: 'westeurope'
  properties: {
    virtualNetwork: {
      id: virtualNetworks_vnet3f_jfiwn_name_resource.id
    }
  }
}

resource virtualNetworks_vnet3f_jfiwn_name_inbound 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet3f_jfiwn_name}/inbound'
  properties: {
    addressPrefix: '10.62.0.0/28'
    delegations: [
      {
        name: 'dnsResolverDelegation'
        id: '${virtualNetworks_vnet3f_jfiwn_name_inbound.id}/delegations/dnsResolverDelegation'
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
    virtualNetworks_vnet3f_jfiwn_name_resource
  ]
}

resource dnsResolvers_dnsrb_031p_1_name_inbound61hwdf 'Microsoft.Network/dnsResolvers/inboundEndpoints@2025-10-01-preview' = {
  parent: dnsResolvers_dnsrb_031p_1_name_resource
  name: 'inbound61hwdf'
  location: 'westeurope'
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: virtualNetworks_vnet3f_jfiwn_name_inbound.id
        }
        privateIpAddress: '10.62.0.4'
        privateIpAllocationMethod: 'Dynamic'
      }
    ]
  }
}


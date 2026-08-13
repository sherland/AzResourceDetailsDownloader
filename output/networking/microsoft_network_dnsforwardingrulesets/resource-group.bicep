param dnsResolvers_dnsrg5d_jfb6_name string
param virtualNetworks_vneterg7184q_name string
param dnsForwardingRulesets_dfrsd_86_jjd_name string

resource virtualNetworks_vneterg7184q_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vneterg7184q_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.60.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'outbound'
        id: virtualNetworks_vneterg7184q_name_outbound.id
        properties: {
          addressPrefix: '10.60.1.0/28'
          delegations: [
            {
              name: 'dnsResolverDelegation'
              id: '${virtualNetworks_vneterg7184q_name_outbound.id}/delegations/dnsResolverDelegation'
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

resource dnsForwardingRulesets_dfrsd_86_jjd_name_resource 'Microsoft.Network/dnsForwardingRulesets@2025-10-01-preview' = {
  name: dnsForwardingRulesets_dfrsd_86_jjd_name
  location: 'norwayeast'
  properties: {
    dnsResolverOutboundEndpoints: [
      {
        id: dnsResolvers_dnsrg5d_jfb6_name_outboundtnd_yz.id
      }
    ]
  }
}

resource dnsResolvers_dnsrg5d_jfb6_name_resource 'Microsoft.Network/dnsResolvers@2025-10-01-preview' = {
  name: dnsResolvers_dnsrg5d_jfb6_name
  location: 'norwayeast'
  properties: {
    virtualNetwork: {
      id: virtualNetworks_vneterg7184q_name_resource.id
    }
  }
}

resource virtualNetworks_vneterg7184q_name_outbound 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vneterg7184q_name}/outbound'
  properties: {
    addressPrefix: '10.60.1.0/28'
    delegations: [
      {
        name: 'dnsResolverDelegation'
        id: '${virtualNetworks_vneterg7184q_name_outbound.id}/delegations/dnsResolverDelegation'
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
    virtualNetworks_vneterg7184q_name_resource
  ]
}

resource dnsResolvers_dnsrg5d_jfb6_name_outboundtnd_yz 'Microsoft.Network/dnsResolvers/outboundEndpoints@2025-10-01-preview' = {
  parent: dnsResolvers_dnsrg5d_jfb6_name_resource
  name: 'outboundtnd-yz'
  location: 'norwayeast'
  properties: {
    subnet: {
      id: virtualNetworks_vneterg7184q_name_outbound.id
    }
  }
}


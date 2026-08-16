param services_dmsc4_b4_nf_name string
param virtualNetworks_vnet46_vasrl_name string
param networkInterfaces_NIC_vznhg9v47dgbhh7vcjxyjmrf_name string

resource virtualNetworks_vnet46_vasrl_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnet46_vasrl_name
  location: 'norwayeast'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.81.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnet46_vasrl_name_default.id
        properties: {
          addressPrefix: '10.81.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource networkInterfaces_NIC_vznhg9v47dgbhh7vcjxyjmrf_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_NIC_vznhg9v47dgbhh7vcjxyjmrf_name
  location: 'norwayeast'
  tags: {
    ServiceResourceId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-862cc1ebaeeac2bb/providers/Microsoft.DataMigration/services/dmsc4-b4-nf'
  }
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig'
        id: '${networkInterfaces_NIC_vznhg9v47dgbhh7vcjxyjmrf_name_resource.id}/ipConfigurations/ipconfig'
        properties: {
          privateIPAddress: '10.81.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnet46_vasrl_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: true
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource virtualNetworks_vnet46_vasrl_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnet46_vasrl_name}/default'
  properties: {
    addressPrefix: '10.81.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet46_vasrl_name_resource
  ]
}

resource services_dmsc4_b4_nf_name_resource 'Microsoft.DataMigration/services@2025-09-01-preview' = {
  name: services_dmsc4_b4_nf_name
  location: 'norwayeast'
  sku: {
    name: 'Premium_4vCores'
    size: '4 vCores'
    tier: 'Premium'
  }
  kind: 'Cloud'
  properties: {
    virtualNicId: networkInterfaces_NIC_vznhg9v47dgbhh7vcjxyjmrf_name_resource.id
    virtualSubnetId: virtualNetworks_vnet46_vasrl_name_default.id
  }
}


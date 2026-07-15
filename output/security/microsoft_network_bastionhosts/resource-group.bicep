param bastionHosts_bastiont9y5_i_name string
param virtualNetworks_vnetdrf_xp_d_name string
param publicIPAddresses_pipos_z0e42_name string

resource publicIPAddresses_pipos_z0e42_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pipos_z0e42_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '74.234.209.211'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnetdrf_xp_d_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetdrf_xp_d_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.44.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'AzureBastionSubnet'
        id: virtualNetworks_vnetdrf_xp_d_name_AzureBastionSubnet.id
        properties: {
          addressPrefix: '10.44.255.0/26'
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

resource virtualNetworks_vnetdrf_xp_d_name_AzureBastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetdrf_xp_d_name}/AzureBastionSubnet'
  properties: {
    addressPrefix: '10.44.255.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetdrf_xp_d_name_resource
  ]
}

resource bastionHosts_bastiont9y5_i_name_resource 'Microsoft.Network/bastionHosts@2025-07-01' = {
  name: bastionHosts_bastiont9y5_i_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
  }
  properties: {
    dnsName: 'bst-3f9bce02-16d2-4999-9bd5-644d3b08eed3.bastion.azure.com'
    scaleUnits: 2
    ipConfigurations: [
      {
        name: 'bastionIpConfig'
        id: '${bastionHosts_bastiont9y5_i_name_resource.id}/bastionHostIpConfigurations/bastionIpConfig'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_pipos_z0e42_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnetdrf_xp_d_name_AzureBastionSubnet.id
          }
        }
      }
    ]
  }
}


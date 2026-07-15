param azureFirewalls_afwd5edfm_name string
param virtualNetworks_vnetw4qxan_j_name string
param publicIPAddresses_piph5_e48_s_name string
param publicIPAddresses_pipunesj_jt_name string

resource publicIPAddresses_piph5_e48_s_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_piph5_e48_s_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.105.131.10'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource publicIPAddresses_pipunesj_jt_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pipunesj_jt_name
  location: 'westeurope'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.23.224.126'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnetw4qxan_j_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetw4qxan_j_name
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.45.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        id: virtualNetworks_vnetw4qxan_j_name_AzureFirewallSubnet.id
        properties: {
          addressPrefix: '10.45.255.0/26'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'AzureFirewallManagementSubnet'
        id: virtualNetworks_vnetw4qxan_j_name_AzureFirewallManagementSubnet.id
        properties: {
          addressPrefix: '10.45.254.0/26'
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

resource virtualNetworks_vnetw4qxan_j_name_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetw4qxan_j_name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: '10.45.254.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetw4qxan_j_name_resource
  ]
}

resource virtualNetworks_vnetw4qxan_j_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetw4qxan_j_name}/AzureFirewallSubnet'
  properties: {
    addressPrefix: '10.45.255.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetw4qxan_j_name_resource
  ]
}

resource azureFirewalls_afwd5edfm_name_resource 'Microsoft.Network/azureFirewalls@2025-07-01' = {
  name: azureFirewalls_afwd5edfm_name
  location: 'westeurope'
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Basic'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    managementIpConfiguration: {
      name: 'afwMgmtIpConfig'
      id: '${azureFirewalls_afwd5edfm_name_resource.id}/azureFirewallIpConfigurations/afwMgmtIpConfig'
      properties: {
        publicIPAddress: {
          id: publicIPAddresses_pipunesj_jt_name_resource.id
        }
        subnet: {
          id: virtualNetworks_vnetw4qxan_j_name_AzureFirewallManagementSubnet.id
        }
      }
    }
    ipConfigurations: [
      {
        name: 'afwIpConfig'
        id: '${azureFirewalls_afwd5edfm_name_resource.id}/azureFirewallIpConfigurations/afwIpConfig'
        properties: {
          publicIPAddress: {
            id: publicIPAddresses_piph5_e48_s_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnetw4qxan_j_name_AzureFirewallSubnet.id
          }
        }
      }
    ]
    networkRuleCollections: []
    applicationRuleCollections: []
    natRuleCollections: []
  }
}


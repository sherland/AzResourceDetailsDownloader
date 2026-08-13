param azureFirewalls_afwvzgvaw_name string
param virtualNetworks_vnetfdgcru_j_name string
param publicIPAddresses_pip7ia9_tq4_name string
param publicIPAddresses_piptlxkj0_6_name string

resource publicIPAddresses_pip7ia9_tq4_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_pip7ia9_tq4_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '51.120.77.94'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource publicIPAddresses_piptlxkj0_6_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_piptlxkj0_6_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '20.100.168.149'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_vnetfdgcru_j_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetfdgcru_j_name
  location: 'norwayeast'
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
        id: virtualNetworks_vnetfdgcru_j_name_AzureFirewallSubnet.id
        properties: {
          addressPrefix: '10.45.255.0/26'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'AzureFirewallManagementSubnet'
        id: virtualNetworks_vnetfdgcru_j_name_AzureFirewallManagementSubnet.id
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

resource virtualNetworks_vnetfdgcru_j_name_AzureFirewallManagementSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetfdgcru_j_name}/AzureFirewallManagementSubnet'
  properties: {
    addressPrefix: '10.45.254.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetfdgcru_j_name_resource
  ]
}

resource virtualNetworks_vnetfdgcru_j_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetfdgcru_j_name}/AzureFirewallSubnet'
  properties: {
    addressPrefix: '10.45.255.0/26'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetfdgcru_j_name_resource
  ]
}

resource azureFirewalls_afwvzgvaw_name_resource 'Microsoft.Network/azureFirewalls@2025-07-01' = {
  name: azureFirewalls_afwvzgvaw_name
  location: 'norwayeast'
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Basic'
    }
    threatIntelMode: 'Alert'
    additionalProperties: {}
    managementIpConfiguration: {
      name: 'afwMgmtIpConfig'
      id: '${azureFirewalls_afwvzgvaw_name_resource.id}/azureFirewallIpConfigurations/afwMgmtIpConfig'
      properties: {
        publicIPAddress: {
          id: publicIPAddresses_piptlxkj0_6_name_resource.id
        }
        subnet: {
          id: virtualNetworks_vnetfdgcru_j_name_AzureFirewallManagementSubnet.id
        }
      }
    }
    ipConfigurations: [
      {
        name: 'afwIpConfig'
        id: '${azureFirewalls_afwvzgvaw_name_resource.id}/azureFirewallIpConfigurations/afwIpConfig'
        properties: {
          publicIPAddress: {
            id: publicIPAddresses_pip7ia9_tq4_name_resource.id
          }
          subnet: {
            id: virtualNetworks_vnetfdgcru_j_name_AzureFirewallSubnet.id
          }
        }
      }
    ]
    networkRuleCollections: []
    applicationRuleCollections: []
    natRuleCollections: []
  }
}


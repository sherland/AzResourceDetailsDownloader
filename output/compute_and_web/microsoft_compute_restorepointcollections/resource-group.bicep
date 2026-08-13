param virtualNetworks_vnetgb8_lmu3_name string
param networkInterfaces_nicu7u_tk0w_name string
param virtualMachines_swazx8jrlti5t02_name string
param restorePointCollections_rpcfzx_zcdq_name string

resource virtualNetworks_vnetgb8_lmu3_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetgb8_lmu3_name
  location: 'swedencentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.70.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnetgb8_lmu3_name_default.id
        properties: {
          addressPrefix: '10.70.0.0/24'
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

resource restorePointCollections_rpcfzx_zcdq_name_resource 'Microsoft.Compute/restorePointCollections@2025-11-01' = {
  name: restorePointCollections_rpcfzx_zcdq_name
  location: 'swedencentral'
  properties: {
    source: {
      id: virtualMachines_swazx8jrlti5t02_name_resource.id
    }
  }
}

resource virtualMachines_swazx8jrlti5t02_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_swazx8jrlti5t02_name
  location: 'swedencentral'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v5'
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_swazx8jrlti5t02_name}_disk1_a3e223fa84a94a9a86331551421d70a7'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_swazx8jrlti5t02_name}_disk1_a3e223fa84a94a9a86331551421d70a7'
          )
        }
        deleteOption: 'Detach'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: 'ardlvm2'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: true
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azrddadmin'
    }
    securityProfile: {
      securityType: 'Standard'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_nicu7u_tk0w_name_resource.id
        }
      ]
    }
  }
}

resource networkInterfaces_nicu7u_tk0w_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_nicu7u_tk0w_name
  location: 'swedencentral'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_nicu7u_tk0w_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.70.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnetgb8_lmu3_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource virtualNetworks_vnetgb8_lmu3_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetgb8_lmu3_name}/default'
  properties: {
    addressPrefix: '10.70.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetgb8_lmu3_name_resource
  ]
}


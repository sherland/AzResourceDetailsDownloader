param virtualNetworks_vnetb5ylw2_a_name string
param networkInterfaces_nicdr_jirpw_name string
param virtualMachines_swazfidx9hmdq01_name string

resource virtualNetworks_vnetb5ylw2_a_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetb5ylw2_a_name
  location: 'swedencentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.30.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnetb5ylw2_a_name_default.id
        properties: {
          addressPrefix: '10.30.0.0/24'
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

resource virtualMachines_swazfidx9hmdq01_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_swazfidx9hmdq01_name
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
        name: '${virtualMachines_swazfidx9hmdq01_name}_disk1_088239d7c12348ceb3cf69a0d245bbf4'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_swazfidx9hmdq01_name}_disk1_088239d7c12348ceb3cf69a0d245bbf4'
          )
        }
        deleteOption: 'Detach'
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: 'ardlvm'
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
          id: networkInterfaces_nicdr_jirpw_name_resource.id
        }
      ]
    }
  }
}

resource networkInterfaces_nicdr_jirpw_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_nicdr_jirpw_name
  location: 'swedencentral'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_nicdr_jirpw_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.30.0.4'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_vnetb5ylw2_a_name_default.id
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

resource virtualNetworks_vnetb5ylw2_a_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetb5ylw2_a_name}/default'
  properties: {
    addressPrefix: '10.30.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetb5ylw2_a_name_resource
  ]
}


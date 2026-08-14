param virtualNetworks_vnetu_axjz1a_name string
param virtualMachineScaleSets_vmssrd5qq3_name string
param disks_vmssrd5qq3_vmssrd5qq3_0_OsDisk_1_7cbdc144f100423487c0b6b56e3a8da3_externalid string

resource virtualNetworks_vnetu_axjz1a_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetu_axjz1a_name
  location: 'swedencentral'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.46.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'default'
        id: virtualNetworks_vnetu_axjz1a_name_default.id
        properties: {
          addressPrefix: '10.46.0.0/24'
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

resource virtualMachineScaleSets_vmssrd5qq3_name_resource 'Microsoft.Compute/virtualMachineScaleSets@2025-11-01' = {
  name: virtualMachineScaleSets_vmssrd5qq3_name
  location: 'swedencentral'
  sku: {
    name: 'Standard_D2s_v5'
    tier: 'Standard'
    capacity: 1
  }
  properties: {
    singlePlacementGroup: true
    orchestrationMode: 'Uniform'
    upgradePolicy: {
      mode: 'Manual'
    }
    virtualMachineProfile: {
      osProfile: {
        computerNamePrefix: 'ardlvmss'
        linuxConfiguration: {
          disablePasswordAuthentication: false
          provisionVMAgent: true
          enableVMAgentPlatformUpdates: true
        }
        secrets: []
        allowExtensionOperations: true
        requireGuestProvisionSignal: true
        adminUsername: 'azrddadmin'
      }
      storageProfile: {
        osDisk: {
          osType: 'Linux'
          createOption: 'FromImage'
          caching: 'None'
          managedDisk: {
            storageAccountType: 'Premium_LRS'
          }
          diskSizeGB: 30
        }
        imageReference: {
          publisher: 'Canonical'
          offer: '0001-com-ubuntu-server-jammy'
          sku: '22_04-lts'
          version: 'latest'
        }
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nicconfig1'
            properties: {
              primary: true
              disableTcpStateTracking: false
              dnsSettings: {
                dnsServers: []
              }
              enableIPForwarding: false
              ipConfigurations: [
                {
                  name: 'ipconfig1'
                  properties: {
                    subnet: {
                      id: virtualNetworks_vnetu_axjz1a_name_default.id
                    }
                    privateIPAddressVersion: 'IPv4'
                  }
                }
              ]
            }
          }
        ]
      }
      securityProfile: {
        securityType: 'Standard'
      }
    }
    overprovision: true
    doNotRunExtensionsOnOverprovisionedVMs: false
    platformFaultDomainCount: 5
  }
}

resource virtualNetworks_vnetu_axjz1a_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetu_axjz1a_name}/default'
  properties: {
    addressPrefix: '10.46.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetu_axjz1a_name_resource
  ]
}

resource virtualMachineScaleSets_vmssrd5qq3_name_0 'Microsoft.Compute/virtualMachineScaleSets/virtualMachines@2025-11-01' = {
  parent: virtualMachineScaleSets_vmssrd5qq3_name_resource
  name: '0'
  location: 'swedencentral'
  sku: {
    name: 'Standard_D2s_v5'
    tier: 'Standard'
  }
  properties: {
    networkProfileConfiguration: {
      networkInterfaceConfigurations: [
        {
          name: 'nicconfig1'
          properties: {
            primary: true
            disableTcpStateTracking: false
            dnsSettings: {
              dnsServers: []
            }
            enableIPForwarding: false
            ipConfigurations: [
              {
                name: 'ipconfig1'
                properties: {
                  subnet: {
                    id: virtualNetworks_vnetu_axjz1a_name_default.id
                  }
                  privateIPAddressVersion: 'IPv4'
                }
              }
            ]
          }
        }
      ]
    }
    hardwareProfile: {
      vmSize: 'Standard_D2s_v5'
    }
    resilientVMDeletionStatus: 'Disabled'
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: 'vmssrd5qq3_vmssrd5qq3_0_OsDisk_1_7cbdc144f100423487c0b6b56e3a8da3'
        createOption: 'FromImage'
        caching: 'None'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_vmssrd5qq3_vmssrd5qq3_0_OsDisk_1_7cbdc144f100423487c0b6b56e3a8da3_externalid
        }
        diskSizeGB: 30
      }
      dataDisks: []
    }
    osProfile: {
      computerName: 'ardlvmss000000'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
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
          id: '${virtualMachineScaleSets_vmssrd5qq3_name_0.id}/networkInterfaces/nicconfig1'
        }
      ]
    }
  }
}


param virtualNetworks_vnetd7_ts_wt_name string
param virtualMachineScaleSets_vmsswdgknl_name string
param disks_vmsswdgknl_vmsswdgknl_0_OsDisk_1_3903b4610f264eb0baa06194b2aa59d6_externalid string

resource virtualNetworks_vnetd7_ts_wt_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_vnetd7_ts_wt_name
  location: 'westeurope'
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
        id: virtualNetworks_vnetd7_ts_wt_name_default.id
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

resource virtualMachineScaleSets_vmsswdgknl_name_resource 'Microsoft.Compute/virtualMachineScaleSets@2025-11-01' = {
  name: virtualMachineScaleSets_vmsswdgknl_name
  location: 'westeurope'
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
                      id: virtualNetworks_vnetd7_ts_wt_name_default.id
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

resource virtualNetworks_vnetd7_ts_wt_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_vnetd7_ts_wt_name}/default'
  properties: {
    addressPrefix: '10.46.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnetd7_ts_wt_name_resource
  ]
}

resource virtualMachineScaleSets_vmsswdgknl_name_0 'Microsoft.Compute/virtualMachineScaleSets/virtualMachines@2025-11-01' = {
  parent: virtualMachineScaleSets_vmsswdgknl_name_resource
  name: '0'
  location: 'westeurope'
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
                    id: virtualNetworks_vnetd7_ts_wt_name_default.id
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
        name: 'vmsswdgknl_vmsswdgknl_0_OsDisk_1_3903b4610f264eb0baa06194b2aa59d6'
        createOption: 'FromImage'
        caching: 'None'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
          id: disks_vmsswdgknl_vmsswdgknl_0_OsDisk_1_3903b4610f264eb0baa06194b2aa59d6_externalid
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
          id: '${virtualMachineScaleSets_vmsswdgknl_name_0.id}/networkInterfaces/nicconfig1'
        }
      ]
    }
  }
}


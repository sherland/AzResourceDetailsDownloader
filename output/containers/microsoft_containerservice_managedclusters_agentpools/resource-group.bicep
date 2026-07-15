param managedClusters_aks5fhg_mju_name string
param userAssignedIdentities_aks5fhg_mju_agentpool_externalid string

resource managedClusters_aks5fhg_mju_name_resource 'Microsoft.ContainerService/managedClusters@2026-04-02-preview' = {
  name: managedClusters_aks5fhg_mju_name
  location: 'westeurope'
  sku: {
    name: 'Base'
    tier: 'Free'
  }
  kind: 'Base'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.35'
    dnsPrefix: 'ardlakswjzfkt'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_D2s_v5'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        maxPods: 250
        type: 'VirtualMachineScaleSets'
        scaleDownMode: 'Delete'
        powerState: {
          code: 'Running'
        }
        orchestratorVersion: '1.35'
        enableNodePublicIP: false
        mode: 'System'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        nodeImageVersion: 'AKSUbuntu-2404gen2containerd-202606.19.0'
        upgradeSettings: {
          maxSurge: '10%'
          maxUnavailable: '0'
        }
        enableFIPS: false
        securityProfile: {
          sshAccess: 'LocalUser'
          enableVTPM: false
          enableSecureBoot: false
        }
      }
      {
        name: 'pool2'
        count: 1
        vmSize: 'Standard_D2s_v5'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        maxPods: 250
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: false
        scaleDownMode: 'Delete'
        powerState: {
          code: 'Running'
        }
        orchestratorVersion: '1.35'
        enableNodePublicIP: false
        mode: 'User'
        osType: 'Linux'
        osSKU: 'Ubuntu'
        nodeImageVersion: 'AKSUbuntu-2404gen2containerd-202606.19.0'
        upgradeSettings: {
          maxSurge: '10%'
          maxUnavailable: '0'
        }
        enableFIPS: false
        securityProfile: {
          sshAccess: 'LocalUser'
          enableVTPM: false
          enableSecureBoot: false
        }
      }
    ]
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    nodeResourceGroup: 'MC_rg-ardl-72e8c58f3ece7542_${managedClusters_aks5fhg_mju_name}_westeurope'
    enableRBAC: true
    supportPlan: 'KubernetesOfficial'
    networkProfile: {
      networkPlugin: 'azure'
      networkPluginMode: 'overlay'
      networkPolicy: 'none'
      networkDataplane: 'azure'
      loadBalancerSku: 'standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
        backendPoolType: 'nodeIPConfiguration'
      }
      podCidr: '10.244.0.0/16'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      outboundType: 'loadBalancer'
      podCidrs: [
        '10.244.0.0/16'
      ]
      serviceCidrs: [
        '10.0.0.0/16'
      ]
      ipFamilies: [
        'IPv4'
      ]
      podLinkLocalAccess: 'IMDS'
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: userAssignedIdentities_aks5fhg_mju_agentpool_externalid
        clientId: '7f5c2bc3-b72b-457e-9a03-2c5321b623c7'
        objectId: '0ee6dd5d-965a-4edc-b518-44839921b74c'
      }
    }
    autoUpgradeProfile: {
      nodeOSUpgradeChannel: 'NodeImage'
    }
    securityProfile: {}
    storageProfile: {
      diskCSIDriver: {
        enabled: true
      }
      fileCSIDriver: {
        enabled: true
      }
      snapshotController: {
        enabled: true
      }
    }
    oidcIssuerProfile: {
      enabled: true
    }
    nodeDisruptionProfile: {
      nodeDisruptionPolicy: 'Allow'
    }
    workloadAutoScalerProfile: {}
    metricsProfile: {
      costAnalysis: {
        enabled: false
      }
    }
    nodeProvisioningProfile: {
      mode: 'Manual'
      defaultNodePools: 'Auto'
    }
    bootstrapProfile: {
      artifactSource: 'Direct'
    }
    hostedSystemProfile: {
      enabled: false
    }
    enableFIPS: false
    healthMonitorProfile: {
      enableContinuousControlPlaneAndAddonMonitor: false
      enableOnDemandMonitor: false
    }
  }
}

resource managedClusters_aks5fhg_mju_name_agentpool 'Microsoft.ContainerService/managedClusters/agentPools@2026-04-02-preview' = {
  parent: managedClusters_aks5fhg_mju_name_resource
  name: 'agentpool'
  properties: {
    count: 1
    vmSize: 'Standard_D2s_v5'
    osDiskSizeGB: 128
    osDiskType: 'Managed'
    kubeletDiskType: 'OS'
    maxPods: 250
    type: 'VirtualMachineScaleSets'
    scaleDownMode: 'Delete'
    powerState: {
      code: 'Running'
    }
    orchestratorVersion: '1.35'
    enableNodePublicIP: false
    mode: 'System'
    osType: 'Linux'
    osSKU: 'Ubuntu'
    nodeImageVersion: 'AKSUbuntu-2404gen2containerd-202606.19.0'
    upgradeSettings: {
      maxSurge: '10%'
      maxUnavailable: '0'
    }
    enableFIPS: false
    securityProfile: {
      sshAccess: 'LocalUser'
      enableVTPM: false
      enableSecureBoot: false
    }
  }
}

resource managedClusters_aks5fhg_mju_name_pool2 'Microsoft.ContainerService/managedClusters/agentPools@2026-04-02-preview' = {
  parent: managedClusters_aks5fhg_mju_name_resource
  name: 'pool2'
  properties: {
    count: 1
    vmSize: 'Standard_D2s_v5'
    osDiskSizeGB: 128
    osDiskType: 'Managed'
    kubeletDiskType: 'OS'
    maxPods: 250
    type: 'VirtualMachineScaleSets'
    enableAutoScaling: false
    scaleDownMode: 'Delete'
    powerState: {
      code: 'Running'
    }
    orchestratorVersion: '1.35'
    enableNodePublicIP: false
    mode: 'User'
    osType: 'Linux'
    osSKU: 'Ubuntu'
    nodeImageVersion: 'AKSUbuntu-2404gen2containerd-202606.19.0'
    upgradeSettings: {
      maxSurge: '10%'
      maxUnavailable: '0'
    }
    enableFIPS: false
    securityProfile: {
      sshAccess: 'LocalUser'
      enableVTPM: false
      enableSecureBoot: false
    }
  }
}

resource managedClusters_aks5fhg_mju_name_agentpool_aks_agentpool_24709087_vmss000000 'Microsoft.ContainerService/managedClusters/agentPools/machines@2026-04-02-preview' = {
  parent: managedClusters_aks5fhg_mju_name_agentpool
  name: 'aks-agentpool-24709087-vmss000000'
  properties: {
    network: {}
  }
  dependsOn: [
    managedClusters_aks5fhg_mju_name_resource
  ]
}

resource managedClusters_aks5fhg_mju_name_pool2_aks_pool2_26487404_vmss000000 'Microsoft.ContainerService/managedClusters/agentPools/machines@2026-04-02-preview' = {
  parent: managedClusters_aks5fhg_mju_name_pool2
  name: 'aks-pool2-26487404-vmss000000'
  properties: {
    network: {}
  }
  dependsOn: [
    managedClusters_aks5fhg_mju_name_resource
  ]
}


param managedClusters_aksb4ef4_7r_name string
param userAssignedIdentities_aksb4ef4_7r_agentpool_externalid string

resource managedClusters_aksb4ef4_7r_name_resource 'Microsoft.ContainerService/managedClusters@2026-04-02-preview' = {
  name: managedClusters_aksb4ef4_7r_name
  location: 'swedencentral'
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
    dnsPrefix: 'ardlaksdr835j'
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
        nodeImageVersion: 'AKSUbuntu-2404gen2containerd-202607.29.0'
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
    nodeResourceGroup: 'MC_rg-ardl-7c2bfad159d510c2_${managedClusters_aksb4ef4_7r_name}_swedencentral'
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
        resourceId: userAssignedIdentities_aksb4ef4_7r_agentpool_externalid
        clientId: 'a37aa05e-7d45-4a2a-bc03-a6bfc4e5171a'
        objectId: '3881ecbf-b46c-4a5b-a226-98e4fc5810de'
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

resource managedClusters_aksb4ef4_7r_name_agentpool 'Microsoft.ContainerService/managedClusters/agentPools@2026-04-02-preview' = {
  parent: managedClusters_aksb4ef4_7r_name_resource
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
    nodeImageVersion: 'AKSUbuntu-2404gen2containerd-202607.29.0'
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

resource managedClusters_aksb4ef4_7r_name_agentpool_aks_agentpool_72296233_vmss000000 'Microsoft.ContainerService/managedClusters/agentPools/machines@2026-04-02-preview' = {
  parent: managedClusters_aksb4ef4_7r_name_agentpool
  name: 'aks-agentpool-72296233-vmss000000'
  properties: {
    network: {}
  }
  dependsOn: [
    managedClusters_aksb4ef4_7r_name_resource
  ]
}


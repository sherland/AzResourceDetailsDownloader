param containerapps_ca453klp91_name string
param managedEnvironments_caedj4q0www_name string
param managedEnvironments_caesiujm_j3_name string

resource managedEnvironments_caedj4q0www_name_resource 'Microsoft.App/managedEnvironments@2026-01-01' = {
  name: managedEnvironments_caedj4q0www_name
  location: 'West Europe'
  properties: {
    appLogsConfiguration: {}
    zoneRedundant: false
    kedaConfiguration: {}
    daprConfiguration: {}
    customDomainConfiguration: {}
    peerAuthentication: {
      mtls: {
        enabled: false
      }
    }
    peerTrafficConfiguration: {
      encryption: {
        enabled: false
      }
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource managedEnvironments_caesiujm_j3_name_resource 'Microsoft.App/managedEnvironments@2026-01-01' = {
  name: managedEnvironments_caesiujm_j3_name
  location: 'France Central'
  properties: {
    appLogsConfiguration: {}
    zoneRedundant: false
    kedaConfiguration: {}
    daprConfiguration: {}
    customDomainConfiguration: {}
    peerAuthentication: {
      mtls: {
        enabled: false
      }
    }
    peerTrafficConfiguration: {
      encryption: {
        enabled: false
      }
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource containerapps_ca453klp91_name_resource 'Microsoft.App/containerapps@2026-01-01' = {
  name: containerapps_ca453klp91_name
  location: 'France Central'
  identity: {
    type: 'None'
  }
  properties: {
    managedEnvironmentId: managedEnvironments_caesiujm_j3_name_resource.id
    environmentId: managedEnvironments_caesiujm_j3_name_resource.id
    configuration: {
      activeRevisionsMode: 'Single'
      ingress: {
        external: true
        targetPort: 80
        exposedPort: 0
        transport: 'Auto'
        traffic: [
          {
            weight: 100
            latestRevision: true
          }
        ]
        allowInsecure: false
      }
      maxInactiveRevisions: 100
      identitySettings: []
    }
    template: {
      containers: [
        {
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          name: 'main'
          resources: {
            cpu: json('0.5')
            memory: '1Gi'
          }
        }
      ]
      scale: {
        maxReplicas: 10
        cooldownPeriod: 300
        pollingInterval: 30
      }
    }
  }
}


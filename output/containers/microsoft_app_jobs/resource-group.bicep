param jobs_cajouo_dwv4_name string
param managedEnvironments_caepmpb42xg_name string

resource managedEnvironments_caepmpb42xg_name_resource 'Microsoft.App/managedEnvironments@2026-01-01' = {
  name: managedEnvironments_caepmpb42xg_name
  location: 'Norway East'
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

resource jobs_cajouo_dwv4_name_resource 'Microsoft.App/jobs@2026-01-01' = {
  name: jobs_cajouo_dwv4_name
  location: 'Norway East'
  identity: {
    type: 'None'
  }
  properties: {
    environmentId: managedEnvironments_caepmpb42xg_name_resource.id
    configuration: {
      triggerType: 'Manual'
      replicaTimeout: 300
      replicaRetryLimit: 0
      manualTriggerConfig: {
        replicaCompletionCount: 1
        parallelism: 1
      }
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
    }
  }
}


param managedEnvironments_caeznfvtm_z_name string

resource managedEnvironments_caeznfvtm_z_name_resource 'Microsoft.App/managedEnvironments@2026-01-01' = {
  name: managedEnvironments_caeznfvtm_z_name
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


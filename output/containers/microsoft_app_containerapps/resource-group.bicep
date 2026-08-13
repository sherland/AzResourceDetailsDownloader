param managedEnvironments_caedj4q0www_name string

resource managedEnvironments_caedj4q0www_name_resource 'Microsoft.App/managedEnvironments@2026-01-01' = {
  name: managedEnvironments_caedj4q0www_name
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


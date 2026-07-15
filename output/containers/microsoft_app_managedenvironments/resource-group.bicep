param managedEnvironments_caef_y_ve5h_name string
param managedEnvironments_caez_5_26_t_name string

resource managedEnvironments_caef_y_ve5h_name_resource 'Microsoft.App/managedEnvironments@2026-01-01' = {
  name: managedEnvironments_caef_y_ve5h_name
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

resource managedEnvironments_caez_5_26_t_name_resource 'Microsoft.App/managedEnvironments@2026-01-01' = {
  name: managedEnvironments_caez_5_26_t_name
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


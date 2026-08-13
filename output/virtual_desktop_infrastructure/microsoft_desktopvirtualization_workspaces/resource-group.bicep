param workspaces_avdwsut7n7sj2_name string

resource workspaces_avdwsut7n7sj2_name_resource 'Microsoft.DesktopVirtualization/workspaces@2026-03-01-preview' = {
  name: workspaces_avdwsut7n7sj2_name
  location: 'northeurope'
  properties: {
    deploymentScope: 'Geographical'
    publicNetworkAccess: 'Enabled'
    applicationGroupReferences: []
  }
}


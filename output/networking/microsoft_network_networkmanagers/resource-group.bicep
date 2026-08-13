param networkManagers_vnmpd_y3wzq_name string

resource networkManagers_vnmpd_y3wzq_name_resource 'Microsoft.Network/networkManagers@2025-07-01' = {
  name: networkManagers_vnmpd_y3wzq_name
  location: 'norwayeast'
  properties: {
    networkManagerScopes: {
      managementGroups: []
      subscriptions: [
        '/subscriptions/00000000-0000-0000-0000-000000000000'
      ]
    }
    networkManagerScopeAccesses: [
      'Connectivity'
      'SecurityAdmin'
    ]
  }
}


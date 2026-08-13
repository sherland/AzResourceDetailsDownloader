param routeTables_rt3nepn_8s_name string

resource routeTables_rt3nepn_8s_name_resource 'Microsoft.Network/routeTables@2025-07-01' = {
  name: routeTables_rt3nepn_8s_name
  location: 'norwayeast'
  properties: {
    disableBgpRoutePropagation: false
    routes: []
  }
}


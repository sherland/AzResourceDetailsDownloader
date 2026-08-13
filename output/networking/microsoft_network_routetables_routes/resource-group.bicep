param routeTables_rtjowsda_7_name string

resource routeTables_rtjowsda_7_name_resource 'Microsoft.Network/routeTables@2025-07-01' = {
  name: routeTables_rtjowsda_7_name
  location: 'norwayeast'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'routejzqqmb'
        id: routeTables_rtjowsda_7_name_routejzqqmb.id
        properties: {
          addressPrefix: '10.99.0.0/24'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.99.0.4'
        }
      }
    ]
  }
}

resource routeTables_rtjowsda_7_name_routejzqqmb 'Microsoft.Network/routeTables/routes@2025-07-01' = {
  name: '${routeTables_rtjowsda_7_name}/routejzqqmb'
  properties: {
    addressPrefix: '10.99.0.0/24'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.99.0.4'
  }
  dependsOn: [
    routeTables_rtjowsda_7_name_resource
  ]
}


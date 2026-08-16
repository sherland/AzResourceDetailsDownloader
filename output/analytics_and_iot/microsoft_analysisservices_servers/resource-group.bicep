param servers_asrivqjljz_name string

resource servers_asrivqjljz_name_resource 'Microsoft.AnalysisServices/servers@2017-08-01' = {
  name: servers_asrivqjljz_name
  location: 'North Europe'
  sku: {
    name: 'D1'
    tier: 'Development'
    capacity: 1
  }
  properties: {
    managedMode: 1
    asAdministrators: {
      members: [
        '22222222-2222-2222-2222-222222222222'
      ]
    }
    querypoolConnectionMode: 'All'
    serverMonitorMode: 1
  }
}


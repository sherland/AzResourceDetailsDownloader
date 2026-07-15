param dashboards_dashm4vvt9ry_name string

resource dashboards_dashm4vvt9ry_name_resource 'Microsoft.Portal/dashboards@2025-04-01-preview' = {
  name: dashboards_dashm4vvt9ry_name
  location: 'westeurope'
  tags: {
    'hidden-title': 'ARDL Dashboard'
  }
  properties: {
    lenses: []
  }
}


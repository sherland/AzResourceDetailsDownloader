param dashboards_dashhb_yt3kg_name string

resource dashboards_dashhb_yt3kg_name_resource 'Microsoft.Portal/dashboards@2025-04-01-preview' = {
  name: dashboards_dashhb_yt3kg_name
  location: 'norwayeast'
  tags: {
    'hidden-title': 'ARDL Dashboard'
  }
  properties: {
    lenses: []
  }
}


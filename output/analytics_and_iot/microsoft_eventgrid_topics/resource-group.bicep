param topics_egt1y0so60i_name string

resource topics_egt1y0so60i_name_resource 'Microsoft.EventGrid/topics@2025-07-15-preview' = {
  name: topics_egt1y0so60i_name
  location: 'norwayeast'
  sku: {
    name: 'Basic'
  }
  kind: 'Azure'
  properties: {
    minimumTlsVersionAllowed: '1.0'
    inputSchema: 'EventGridSchema'
    publicNetworkAccess: 'Enabled'
    dataResidencyBoundary: 'WithinGeopair'
  }
}


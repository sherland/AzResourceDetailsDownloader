param namespaces_egns9co_cfa8_name string

resource namespaces_egns9co_cfa8_name_resource 'Microsoft.EventGrid/namespaces@2025-07-15-preview' = {
  name: namespaces_egns9co_cfa8_name
  location: 'norwayeast'
  sku: {
    name: 'Standard'
    capacity: 1
  }
  properties: {
    topicsConfiguration: {}
    isZoneRedundant: true
    publicNetworkAccess: 'Enabled'
    minimumTlsVersionAllowed: '1.2'
  }
}


param namespaces_egns153_8_ez_name string

resource namespaces_egns153_8_ez_name_resource 'Microsoft.EventGrid/namespaces@2025-07-15-preview' = {
  name: namespaces_egns153_8_ez_name
  location: 'westeurope'
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


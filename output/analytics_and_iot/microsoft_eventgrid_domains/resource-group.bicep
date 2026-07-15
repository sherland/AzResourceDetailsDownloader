param domains_egduzo_u3om_name string

resource domains_egduzo_u3om_name_resource 'Microsoft.EventGrid/domains@2025-07-15-preview' = {
  name: domains_egduzo_u3om_name
  location: 'westeurope'
  sku: {
    name: 'Basic'
  }
  properties: {
    minimumTlsVersionAllowed: '1.0'
    inputSchema: 'EventGridSchema'
    publicNetworkAccess: 'Enabled'
    dataResidencyBoundary: 'WithinGeopair'
  }
}


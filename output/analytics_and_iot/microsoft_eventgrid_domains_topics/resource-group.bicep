param domains_egdy_n1aqei_name string

resource domains_egdy_n1aqei_name_resource 'Microsoft.EventGrid/domains@2025-07-15-preview' = {
  name: domains_egdy_n1aqei_name
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

resource domains_egdy_n1aqei_name_topicc_yh_q 'Microsoft.EventGrid/domains/topics@2025-07-15-preview' = {
  parent: domains_egdy_n1aqei_name_resource
  name: 'topicc-yh-q'
}


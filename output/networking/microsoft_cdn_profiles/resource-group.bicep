param profiles_cdncz_d9z3m_name string

resource profiles_cdncz_d9z3m_name_resource 'Microsoft.Cdn/profiles@2025-12-01' = {
  name: profiles_cdncz_d9z3m_name
  location: 'Global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  kind: 'frontdoor'
  properties: {
    originResponseTimeoutSeconds: 30
  }
}


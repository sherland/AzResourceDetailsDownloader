param profiles_cdnm8_y_pfd_name string

resource profiles_cdnm8_y_pfd_name_resource 'Microsoft.Cdn/profiles@2025-12-01' = {
  name: profiles_cdnm8_y_pfd_name
  location: 'Global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  kind: 'frontdoor'
  properties: {
    originResponseTimeoutSeconds: 30
  }
}

resource profiles_cdnm8_y_pfd_name_afdepl_85k0 'Microsoft.Cdn/profiles/afdendpoints@2025-12-01' = {
  parent: profiles_cdnm8_y_pfd_name_resource
  name: 'afdepl-85k0'
  location: 'Global'
  properties: {
    enabledState: 'Enabled'
  }
}


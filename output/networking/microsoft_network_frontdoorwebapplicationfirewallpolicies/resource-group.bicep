param frontdoorwebapplicationfirewallpolicies_fdwaf35amo4nv_name string

resource frontdoorwebapplicationfirewallpolicies_fdwaf35amo4nv_name_resource 'Microsoft.Network/frontdoorwebapplicationfirewallpolicies@2025-11-01' = {
  name: frontdoorwebapplicationfirewallpolicies_fdwaf35amo4nv_name
  location: 'Global'
  sku: {
    name: 'Standard_AzureFrontDoor'
  }
  properties: {
    policySettings: {
      enabledState: 'Enabled'
      mode: 'Prevention'
      requestBodyCheck: 'Enabled'
    }
    customRules: {
      rules: []
    }
    managedRules: {
      managedRuleSets: []
      exceptionsList: {
        exceptions: []
      }
    }
  }
}


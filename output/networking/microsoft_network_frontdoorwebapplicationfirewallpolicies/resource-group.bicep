param frontdoorwebapplicationfirewallpolicies_fdwafkpcnurup_name string

resource frontdoorwebapplicationfirewallpolicies_fdwafkpcnurup_name_resource 'Microsoft.Network/frontdoorwebapplicationfirewallpolicies@2025-11-01' = {
  name: frontdoorwebapplicationfirewallpolicies_fdwafkpcnurup_name
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


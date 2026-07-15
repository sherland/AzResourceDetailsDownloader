param ApplicationGatewayWebApplicationFirewallPolicies_wafiorgu_xh_name string

resource ApplicationGatewayWebApplicationFirewallPolicies_wafiorgu_xh_name_resource 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2025-07-01' = {
  name: ApplicationGatewayWebApplicationFirewallPolicies_wafiorgu_xh_name
  location: 'westeurope'
  properties: {
    customRules: []
    policySettings: {
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
      state: 'Enabled'
      mode: 'Prevention'
      requestBodyInspectLimitInKB: 128
      fileUploadEnforcement: true
      requestBodyEnforcement: true
    }
    managedRules: {
      managedRuleSets: [
        {
          ruleSetType: 'OWASP'
          ruleSetVersion: '3.2'
          ruleGroupOverrides: []
        }
      ]
      exclusions: []
    }
  }
}


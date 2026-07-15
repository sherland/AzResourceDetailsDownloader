param firewallPolicies_afwpd0fjxhjx_name string

resource firewallPolicies_afwpd0fjxhjx_name_resource 'Microsoft.Network/firewallPolicies@2025-07-01' = {
  name: firewallPolicies_afwpd0fjxhjx_name
  location: 'westeurope'
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
  }
}

resource firewallPolicies_afwpd0fjxhjx_name_rulecollz2xglx 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2025-07-01' = {
  parent: firewallPolicies_afwpd0fjxhjx_name_resource
  name: 'rulecollz2xglx'
  location: 'westeurope'
  properties: {
    priority: 100
    ruleCollections: []
  }
}


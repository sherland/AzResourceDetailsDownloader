param firewallPolicies_afwpgkb_kyp1_name string

resource firewallPolicies_afwpgkb_kyp1_name_resource 'Microsoft.Network/firewallPolicies@2025-07-01' = {
  name: firewallPolicies_afwpgkb_kyp1_name
  location: 'norwayeast'
  properties: {
    sku: {
      tier: 'Standard'
    }
    threatIntelMode: 'Alert'
  }
}


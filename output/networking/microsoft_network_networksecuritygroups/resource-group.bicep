param networkSecurityGroups_nsgrk86fdry_name string

resource networkSecurityGroups_nsgrk86fdry_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_nsgrk86fdry_name
  location: 'westeurope'
  properties: {
    securityRules: []
  }
}


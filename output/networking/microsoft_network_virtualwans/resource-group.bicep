param virtualWans_vwanln_0o_eh_name string

resource virtualWans_vwanln_0o_eh_name_resource 'Microsoft.Network/virtualWans@2025-07-01' = {
  name: virtualWans_vwanln_0o_eh_name
  location: 'westeurope'
  properties: {
    disableVpnEncryption: false
    allowBranchToBranchTraffic: true
    type: 'Standard'
  }
}


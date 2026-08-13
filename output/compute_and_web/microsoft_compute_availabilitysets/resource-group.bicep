param availabilitySets_avset6_0q_nt0_name string

resource availabilitySets_avset6_0q_nt0_name_resource 'Microsoft.Compute/availabilitySets@2025-11-01' = {
  name: availabilitySets_avset6_0q_nt0_name
  location: 'norwayeast'
  sku: {
    name: 'Aligned'
  }
  properties: {
    platformUpdateDomainCount: 2
    platformFaultDomainCount: 2
    virtualMachines: []
  }
}


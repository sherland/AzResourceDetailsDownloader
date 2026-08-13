param hostpools_avdhpnqrqlt_t_name string

resource hostpools_avdhpnqrqlt_t_name_resource 'Microsoft.DesktopVirtualization/hostpools@2026-03-01-preview' = {
  name: hostpools_avdhpnqrqlt_t_name
  location: 'northeurope'
  identity: {
    type: 'None'
  }
  properties: {
    allowRDPShortPathWithPrivateLink: 'Disabled'
    deploymentScope: 'Geographical'
    managedPrivateUDP: 'Default'
    directUDP: 'Default'
    publicUDP: 'Default'
    relayUDP: 'Default'
    managementType: 'Standard'
    publicNetworkAccess: 'Enabled'
    hostPoolType: 'Pooled'
    customRdpProperty: 'drivestoredirect:s:;usbdevicestoredirect:s:;redirectclipboard:i:0;redirectprinters:i:0;audiomode:i:0;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;'
    maxSessionLimit: 999999
    loadBalancerType: 'BreadthFirst'
    validationEnvironment: false
    ring: 1
    preferredAppGroupType: 'Desktop'
    startVMOnConnect: false
  }
}


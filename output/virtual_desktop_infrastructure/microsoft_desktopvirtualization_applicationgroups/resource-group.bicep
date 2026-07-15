param hostpools_avdhpz_3v_b_9_name string
param applicationgroups_avdagc_7s_3r1_name string

resource hostpools_avdhpz_3v_b_9_name_resource 'Microsoft.DesktopVirtualization/hostpools@2026-03-01-preview' = {
  name: hostpools_avdhpz_3v_b_9_name
  location: 'westeurope'
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

resource applicationgroups_avdagc_7s_3r1_name_resource 'Microsoft.DesktopVirtualization/applicationgroups@2026-03-01-preview' = {
  name: applicationgroups_avdagc_7s_3r1_name
  location: 'westeurope'
  kind: 'Desktop'
  properties: {
    hostPoolArmPath: hostpools_avdhpz_3v_b_9_name_resource.id
    applicationGroupType: 'Desktop'
  }
}


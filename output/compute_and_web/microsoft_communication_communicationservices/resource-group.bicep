param communicationServices_acso_awg_qq_name string

resource communicationServices_acso_awg_qq_name_resource 'Microsoft.Communication/communicationServices@2026-03-18' = {
  name: communicationServices_acso_awg_qq_name
  location: 'global'
  properties: {
    dataLocation: 'Europe'
  }
}


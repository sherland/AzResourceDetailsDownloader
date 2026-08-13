param emailServices_acsemailo_zy_g_n_name string

resource emailServices_acsemailo_zy_g_n_name_resource 'Microsoft.Communication/emailServices@2026-03-18' = {
  name: emailServices_acsemailo_zy_g_n_name
  location: 'global'
  properties: {
    dataLocation: 'Europe'
  }
}


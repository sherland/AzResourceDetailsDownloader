param staticSites_stapp9n53_4_v_name string

resource staticSites_stapp9n53_4_v_name_resource 'Microsoft.Web/staticSites@2024-11-01' = {
  name: staticSites_stapp9n53_4_v_name
  location: 'West Europe'
  sku: {
    name: 'Free'
    tier: 'Free'
  }
  properties: {
    stagingEnvironmentPolicy: 'Enabled'
    allowConfigFileUpdates: true
    provider: 'None'
    enterpriseGradeCdnStatus: 'Disabled'
  }
}

resource staticSites_stapp9n53_4_v_name_default 'Microsoft.Web/staticSites/basicAuth@2024-11-01' = {
  parent: staticSites_stapp9n53_4_v_name_resource
  name: 'default'
  location: 'West Europe'
  properties: {
    applicableEnvironmentsMode: 'SpecifiedEnvironments'
  }
}


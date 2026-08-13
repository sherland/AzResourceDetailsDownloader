param accessConnectors_dbacarwx6_ka_name string

resource accessConnectors_dbacarwx6_ka_name_resource 'Microsoft.Databricks/accessConnectors@2026-01-01' = {
  name: accessConnectors_dbacarwx6_ka_name
  location: 'norwayeast'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {}
}


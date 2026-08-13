param queries_rgq0ww670ks_name string

resource queries_rgq0ww670ks_name_resource 'microsoft.resourcegraph/queries@2024-04-01' = {
  name: queries_rgq0ww670ks_name
  location: 'global'
  properties: {
    query: 'Resources | take 1'
  }
}


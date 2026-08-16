param queries_rgqnhli_a7r_name string

resource queries_rgqnhli_a7r_name_resource 'microsoft.resourcegraph/queries@2024-04-01' = {
  name: queries_rgqnhli_a7r_name
  location: 'global'
  properties: {
    query: 'Resources | take 1'
  }
}


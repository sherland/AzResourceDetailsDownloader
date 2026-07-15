param searchServices_srchqyqp_wtf_name string

resource searchServices_srchqyqp_wtf_name_resource 'Microsoft.Search/searchServices@2026-03-01-preview' = {
  name: searchServices_srchqyqp_wtf_name
  location: 'West Europe'
  sku: {
    name: 'free'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    endpoint: 'https://${searchServices_srchqyqp_wtf_name}.search.windows.net'
    hostingMode: 'Default'
    computeType: 'Default'
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      ipRules: []
      bypass: 'None'
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
    }
    dataExfiltrationProtections: []
    semanticSearch: 'free'
    knowledgeRetrieval: 'free'
    upgradeAvailable: 'notAvailable'
  }
}


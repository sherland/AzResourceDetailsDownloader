param searchServices_srch1oszr6kr_name string

resource searchServices_srch1oszr6kr_name_resource 'Microsoft.Search/searchServices@2026-03-01-preview' = {
  name: searchServices_srch1oszr6kr_name
  location: 'Norway East'
  sku: {
    name: 'free'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    endpoint: 'https://${searchServices_srch1oszr6kr_name}.search.windows.net'
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
    semanticSearch: 'disabled'
    knowledgeRetrieval: 'free'
    upgradeAvailable: 'notAvailable'
  }
}


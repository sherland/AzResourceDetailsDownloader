param accounts_cogojuhykh8_name string

resource accounts_cogojuhykh8_name_resource 'Microsoft.CognitiveServices/accounts@2026-05-01' = {
  name: accounts_cogojuhykh8_name
  location: 'westeurope'
  sku: {
    name: 'S0'
  }
  kind: 'CognitiveServices'
  properties: {
    apiProperties: {}
    customSubDomainName: 'ardlcog8l2-q-ck'
    allowProjectManagement: false
    publicNetworkAccess: 'Enabled'
  }
}


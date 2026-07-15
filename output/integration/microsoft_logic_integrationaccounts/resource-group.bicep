param integrationAccounts_iani6kgc_1_name string

resource integrationAccounts_iani6kgc_1_name_resource 'Microsoft.Logic/integrationAccounts@2016-06-01' = {
  name: integrationAccounts_iani6kgc_1_name
  location: 'westeurope'
  sku: {
    name: 'Free'
  }
  properties: {
    state: 'Enabled'
    provisioningState: 'Succeeded'
  }
}


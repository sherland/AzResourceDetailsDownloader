param accounts_pviewxur_y95m_name string

resource accounts_pviewxur_y95m_name_resource 'Microsoft.Purview/accounts@2024-04-01-preview' = {
  name: accounts_pviewxur_y95m_name
  location: 'swedencentral'
  sku: {
    name: 'Standard'
    capacity: 1
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    cloudConnectors: {}
    publicNetworkAccess: 'Enabled'
    managedResourceGroupName: 'ardl-purview-managed-rzaim-qz'
    managedResourcesPublicNetworkAccess: 'NotSpecified'
    managedEventHubState: 'Disabled'
    tenantEndpointState: 'Disabled'
  }
}


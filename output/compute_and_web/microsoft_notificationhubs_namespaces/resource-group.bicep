param namespaces_nhnsfb_y_5_5_name string

resource namespaces_nhnsfb_y_5_5_name_resource 'Microsoft.NotificationHubs/namespaces@2023-10-01-preview' = {
  name: namespaces_nhnsfb_y_5_5_name
  location: 'Norway East'
  sku: {
    name: 'Free'
  }
  properties: {
    provisioningState: 'Succeeded'
    status: 'Created'
    namespaceType: 'NotificationHub'
    zoneRedundancy: 'Enabled'
    networkAcls: {}
    publicNetworkAccess: 'Enabled'
  }
}

resource namespaces_nhnsfb_y_5_5_name_RootManageSharedAccessKey 'Microsoft.NotificationHubs/namespaces/authorizationRules@2023-10-01-preview' = {
  parent: namespaces_nhnsfb_y_5_5_name_resource
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Manage'
      'Listen'
      'Send'
    ]
  }
}


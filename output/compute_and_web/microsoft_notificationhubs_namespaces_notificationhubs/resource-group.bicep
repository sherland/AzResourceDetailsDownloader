param namespaces_nhnsmuv5af_w_name string

resource namespaces_nhnsmuv5af_w_name_resource 'Microsoft.NotificationHubs/namespaces@2023-10-01-preview' = {
  name: namespaces_nhnsmuv5af_w_name
  location: 'West Europe'
  sku: {
    name: 'Free'
  }
  properties: {
    provisioningState: 'Succeeded'
    status: 'Created'
    namespaceType: 'NotificationHub'
    zoneRedundancy: 'Disabled'
    networkAcls: {}
    publicNetworkAccess: 'Enabled'
  }
}

resource namespaces_nhnsmuv5af_w_name_RootManageSharedAccessKey 'Microsoft.NotificationHubs/namespaces/authorizationRules@2023-10-01-preview' = {
  parent: namespaces_nhnsmuv5af_w_name_resource
  name: 'RootManageSharedAccessKey'
  properties: {
    rights: [
      'Manage'
      'Listen'
      'Send'
    ]
  }
}

resource namespaces_nhnsmuv5af_w_name_hub7jf4_l 'Microsoft.NotificationHubs/namespaces/notificationHubs@2023-10-01-preview' = {
  parent: namespaces_nhnsmuv5af_w_name_resource
  name: 'hub7jf4-l'
  location: 'West Europe'
  properties: {
    name: 'hub7jf4-l'
    registrationTtl: '10675199.02:48:05.4775807'
  }
}

resource namespaces_nhnsmuv5af_w_name_hub7jf4_l_DefaultFullSharedAccessSignature 'Microsoft.NotificationHubs/namespaces/notificationHubs/authorizationRules@2023-10-01-preview' = {
  parent: namespaces_nhnsmuv5af_w_name_hub7jf4_l
  name: 'DefaultFullSharedAccessSignature'
  properties: {
    rights: [
      'Manage'
      'Listen'
      'Send'
    ]
  }
  dependsOn: [
    namespaces_nhnsmuv5af_w_name_resource
  ]
}

resource namespaces_nhnsmuv5af_w_name_hub7jf4_l_DefaultListenSharedAccessSignature 'Microsoft.NotificationHubs/namespaces/notificationHubs/authorizationRules@2023-10-01-preview' = {
  parent: namespaces_nhnsmuv5af_w_name_hub7jf4_l
  name: 'DefaultListenSharedAccessSignature'
  properties: {
    rights: [
      'Listen'
    ]
  }
  dependsOn: [
    namespaces_nhnsmuv5af_w_name_resource
  ]
}


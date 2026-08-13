param SignalR_sigr3beb_6nx_name string

resource SignalR_sigr3beb_6nx_name_resource 'Microsoft.SignalRService/SignalR@2025-01-01-preview' = {
  name: SignalR_sigr3beb_6nx_name
  location: 'norwayeast'
  sku: {
    name: 'Free_F1'
    tier: 'Free'
    size: 'F1'
    capacity: 1
  }
  kind: 'SignalR'
  properties: {
    tls: {
      clientCertEnabled: false
    }
    features: [
      {
        flag: 'ServiceMode'
        value: 'Default'
        properties: {}
      }
      {
        flag: 'EnableConnectivityLogs'
        value: 'False'
        properties: {}
      }
      {
        flag: 'EnableMessagingLogs'
        value: 'False'
        properties: {}
      }
      {
        flag: 'EnableLiveTrace'
        value: 'False'
        properties: {}
      }
    ]
    cors: {
      allowedOrigins: [
        '*'
      ]
    }
    serverless: {
      connectionTimeoutInSeconds: 30
      keepAliveIntervalInSeconds: 15
    }
    upstream: {}
    networkACLs: {
      defaultAction: 'Deny'
      publicNetwork: {
        allow: [
          'ServerConnection'
          'ClientConnection'
          'RESTAPI'
          'Trace'
        ]
      }
      privateEndpoints: []
      ipRules: [
        {
          value: '0.0.0.0/0'
          action: 'Allow'
        }
        {
          value: '::/0'
          action: 'Allow'
        }
      ]
    }
    applicationFirewall: {
      clientConnectionCountRules: []
      clientTrafficControlRules: []
    }
    publicNetworkAccess: 'Enabled'
    disableLocalAuth: false
    disableAadAuth: false
    regionEndpointEnabled: 'Enabled'
    resourceStopped: 'false'
  }
}


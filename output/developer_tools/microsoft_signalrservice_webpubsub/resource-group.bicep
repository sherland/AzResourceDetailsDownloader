param WebPubSub_wpseg8_bp2f_name string

resource WebPubSub_wpseg8_bp2f_name_resource 'Microsoft.SignalRService/WebPubSub@2025-08-01-preview' = {
  name: WebPubSub_wpseg8_bp2f_name
  location: 'norwayeast'
  sku: {
    name: 'Free_F1'
    tier: 'Free'
    size: 'F1'
    capacity: 1
  }
  kind: 'WebPubSub'
  properties: {
    tls: {
      clientCertEnabled: false
    }
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


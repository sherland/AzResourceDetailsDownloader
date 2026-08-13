param trafficManagerProfiles_tmtb_tu10b_name string

resource trafficManagerProfiles_tmtb_tu10b_name_resource 'Microsoft.Network/trafficManagerProfiles@2024-04-01-preview' = {
  name: trafficManagerProfiles_tmtb_tu10b_name
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Performance'
    dnsConfig: {
      relativeName: 'ardltmt9deegag'
      ttl: 30
    }
    monitorConfig: {
      profileMonitorStatus: 'Inactive'
      protocol: 'HTTPS'
      port: 443
      path: '/'
      intervalInSeconds: 30
      toleratedNumberOfFailures: 3
      timeoutInSeconds: 10
    }
    endpoints: []
    trafficViewEnrollmentStatus: 'Disabled'
  }
}


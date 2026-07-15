param trafficManagerProfiles_tm5okdvd37_name string

resource trafficManagerProfiles_tm5okdvd37_name_resource 'Microsoft.Network/trafficManagerProfiles@2024-04-01-preview' = {
  name: trafficManagerProfiles_tm5okdvd37_name
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Performance'
    dnsConfig: {
      relativeName: 'ardltm65c6rbk1'
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


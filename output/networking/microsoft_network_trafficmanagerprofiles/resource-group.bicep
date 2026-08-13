param trafficManagerProfiles_tmp6fvnh90_name string

resource trafficManagerProfiles_tmp6fvnh90_name_resource 'Microsoft.Network/trafficManagerProfiles@2024-04-01-preview' = {
  name: trafficManagerProfiles_tmp6fvnh90_name
  location: 'global'
  properties: {
    profileStatus: 'Enabled'
    trafficRoutingMethod: 'Performance'
    dnsConfig: {
      relativeName: 'ardltm9t-7pclq'
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


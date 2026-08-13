param managedClusters_sfmcdzd_ox_0_name string

resource managedClusters_sfmcdzd_ox_0_name_resource 'Microsoft.ServiceFabric/managedClusters@2020-01-01-preview' = {
  name: managedClusters_sfmcdzd_ox_0_name
  location: 'norwayeast'
  tags: {
    'SFRP.DisableDefaultOutboundAccess': 'true'
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserName: 'azrddadmin'
    dnsName: 'ardlsfmcjj9reg'
    clientConnectionPort: 19000
    httpGatewayConnectionPort: 19080
  }
}


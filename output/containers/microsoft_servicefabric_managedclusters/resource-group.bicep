param managedClusters_sfmc9_v2v_ub_name string

resource managedClusters_sfmc9_v2v_ub_name_resource 'Microsoft.ServiceFabric/managedClusters@2020-01-01-preview' = {
  name: managedClusters_sfmc9_v2v_ub_name
  location: 'norwayeast'
  tags: {
    'SFRP.DisableDefaultOutboundAccess': 'true'
  }
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserName: 'azrddadmin'
    dnsName: 'ardlsfmc0c-f-h'
    clientConnectionPort: 19000
    httpGatewayConnectionPort: 19080
  }
}


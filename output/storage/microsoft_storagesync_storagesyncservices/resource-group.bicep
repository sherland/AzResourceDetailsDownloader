param storageSyncServices_sss02jpnzm1_name string

resource storageSyncServices_sss02jpnzm1_name_resource 'Microsoft.StorageSync/storageSyncServices@2022-09-01' = {
  name: storageSyncServices_sss02jpnzm1_name
  location: 'norwayeast'
  properties: {
    incomingTrafficPolicy: 'AllowAllTraffic'
    useIdentity: false
  }
}


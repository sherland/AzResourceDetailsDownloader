param storageSyncServices_sssir56p9bl_name string

resource storageSyncServices_sssir56p9bl_name_resource 'Microsoft.StorageSync/storageSyncServices@2022-09-01' = {
  name: storageSyncServices_sssir56p9bl_name
  location: 'norwayeast'
  properties: {
    incomingTrafficPolicy: 'AllowAllTraffic'
    useIdentity: false
  }
}


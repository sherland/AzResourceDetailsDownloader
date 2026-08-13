param ipGroups_ipg9dzw5niw_name string

resource ipGroups_ipg9dzw5niw_name_resource 'Microsoft.Network/ipGroups@2025-07-01' = {
  name: ipGroups_ipg9dzw5niw_name
  location: 'norwayeast'
  properties: {
    ipAddresses: [
      '10.50.0.0/24'
    ]
  }
}


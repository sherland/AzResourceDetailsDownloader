param ipGroups_ipg3612_y64_name string

resource ipGroups_ipg3612_y64_name_resource 'Microsoft.Network/ipGroups@2025-07-01' = {
  name: ipGroups_ipg3612_y64_name
  location: 'norwayeast'
  properties: {
    ipAddresses: [
      '10.50.0.0/24'
    ]
  }
}


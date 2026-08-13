param communicationServices_acs5mq89eka_name string

resource communicationServices_acs5mq89eka_name_resource 'Microsoft.Communication/communicationServices@2026-03-18' = {
  name: communicationServices_acs5mq89eka_name
  location: 'global'
  properties: {
    dataLocation: 'Europe'
  }
}


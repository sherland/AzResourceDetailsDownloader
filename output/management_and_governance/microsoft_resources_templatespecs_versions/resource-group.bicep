param templateSpecs_ts3l4_yx_a_name string

resource templateSpecs_ts3l4_yx_a_name_resource 'Microsoft.Resources/templateSpecs@2022-02-01' = {
  name: templateSpecs_ts3l4_yx_a_name
  location: 'norwayeast'
  properties: {
    displayName: 'ARDL Template Spec'
  }
}

resource templateSpecs_ts3l4_yx_a_name_v1 'Microsoft.Resources/templateSpecs/versions@2022-02-01' = {
  parent: templateSpecs_ts3l4_yx_a_name_resource
  name: 'v1'
  location: 'norwayeast'
  properties: {
    mainTemplate: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}


param workflows_logicrk9nht5e_name string

resource workflows_logicrk9nht5e_name_resource 'Microsoft.Logic/workflows@2017-07-01' = {
  name: workflows_logicrk9nht5e_name
  location: 'norwayeast'
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      triggers: {}
      actions: {}
    }
    parameters: {}
  }
}


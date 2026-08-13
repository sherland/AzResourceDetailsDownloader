param actionRules_apr9zvqwc2v_name string

resource actionRules_apr9zvqwc2v_name_resource 'Microsoft.AlertsManagement/actionRules@2021-08-08' = {
  name: actionRules_apr9zvqwc2v_name
  location: 'global'
  properties: {
    scopes: [
      '/subscriptions/00000000-0000-0000-0000-000000000000'
    ]
    enabled: true
    actions: [
      {
        actionType: 'RemoveAllActionGroups'
      }
    ]
  }
}


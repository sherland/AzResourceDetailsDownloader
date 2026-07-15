param activityLogAlerts_ala5t_j_5_o_name string

resource activityLogAlerts_ala5t_j_5_o_name_resource 'Microsoft.Insights/activityLogAlerts@2026-01-01' = {
  name: activityLogAlerts_ala5t_j_5_o_name
  location: 'global'
  properties: {
    scopes: [
      '/subscriptions/00000000-0000-0000-0000-000000000000'
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'ServiceHealth'
        }
      ]
    }
    enabled: true
    actions: {}
  }
}


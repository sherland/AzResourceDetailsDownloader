param actionGroups_agnmvk1q9b_name string

resource actionGroups_agnmvk1q9b_name_resource 'microsoft.insights/actionGroups@2024-10-01-preview' = {
  name: actionGroups_agnmvk1q9b_name
  location: 'Global'
  properties: {
    groupShortName: 'ardlag'
    enabled: true
    emailReceivers: []
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: []
  }
}


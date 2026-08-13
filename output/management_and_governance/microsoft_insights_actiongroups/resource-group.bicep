param actionGroups_aginbojpd1_name string

resource actionGroups_aginbojpd1_name_resource 'microsoft.insights/actionGroups@2024-10-01-preview' = {
  name: actionGroups_aginbojpd1_name
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


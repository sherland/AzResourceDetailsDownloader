@secure()
param vulnerabilityAssessments_Default_storageContainerPath string
param workspaces_synd92txe0r_name string
param storageAccounts_stjdj4ltxv_name string

resource storageAccounts_stjdj4ltxv_name_resource 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageAccounts_stjdj4ltxv_name
  location: 'norwayeast'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    isHnsEnabled: true
    networkAcls: {
      ipv6Rules: []
      bypass: 'None'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource workspaces_synd92txe0r_name_resource 'Microsoft.Synapse/workspaces@2021-06-01' = {
  name: workspaces_synd92txe0r_name
  location: 'swedencentral'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    defaultDataLakeStorage: {
      createManagedPrivateEndpoint: false
      accountUrl: 'https://stjdj4ltxv.dfs.core.windows.net'
      filesystem: 'synapsefs'
    }
    encryption: {}
    managedResourceGroupName: 'synapseworkspace-managedrg-5b1d1320-e3f2-4d4e-aef5-fffdec6783fa'
    sqlAdministratorLogin: 'azrddadmin'
    privateEndpointConnections: []
    publicNetworkAccess: 'Enabled'
    cspWorkspaceAdminProperties: {
      initialWorkspaceAdminObjectId: 'e580c62a-96a8-430f-96a9-33d936178197'
    }
    trustedServiceBypassEnabled: false
  }
}

resource storageAccounts_stjdj4ltxv_name_default 'Microsoft.Storage/storageAccounts/blobServices@2026-04-01' = {
  parent: storageAccounts_stjdj4ltxv_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    staticWebsite: {
      enabled: false
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_stjdj4ltxv_name_default 'Microsoft.Storage/storageAccounts/fileServices@2026-04-01' = {
  parent: storageAccounts_stjdj4ltxv_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_stjdj4ltxv_name_default 'Microsoft.Storage/storageAccounts/queueServices@2026-04-01' = {
  parent: storageAccounts_stjdj4ltxv_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_stjdj4ltxv_name_default 'Microsoft.Storage/storageAccounts/tableServices@2026-04-01' = {
  parent: storageAccounts_stjdj4ltxv_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource workspaces_synd92txe0r_name_Default 'Microsoft.Synapse/workspaces/auditingSettings@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource Microsoft_Synapse_workspaces_azureADOnlyAuthentications_workspaces_synd92txe0r_name_default 'Microsoft.Synapse/workspaces/azureADOnlyAuthentications@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'default'
  properties: {
    azureADOnlyAuthentication: false
  }
}

resource Microsoft_Synapse_workspaces_dedicatedSQLminimalTlsSettings_workspaces_synd92txe0r_name_default 'Microsoft.Synapse/workspaces/dedicatedSQLminimalTlsSettings@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'default'
  location: 'swedencentral'
  properties: {
    minimalTlsVersion: '1.2'
  }
}

resource Microsoft_Synapse_workspaces_extendedAuditingSettings_workspaces_synd92txe0r_name_Default 'Microsoft.Synapse/workspaces/extendedAuditingSettings@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource workspaces_synd92txe0r_name_AutoResolveIntegrationRuntime 'Microsoft.Synapse/workspaces/integrationruntimes@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'AutoResolveIntegrationRuntime'
  properties: {
    type: 'Managed'
    typeProperties: {
      computeProperties: {
        location: 'AutoResolve'
      }
    }
  }
}

resource Microsoft_Synapse_workspaces_securityAlertPolicies_workspaces_synd92txe0r_name_Default 'Microsoft.Synapse/workspaces/securityAlertPolicies@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
}

resource workspaces_synd92txe0r_name_sqlpool1 'Microsoft.Synapse/workspaces/sqlPools@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'sqlpool1'
  location: 'swedencentral'
  sku: {
    name: 'DW100c'
    capacity: 0
  }
  properties: {
    maxSizeBytes: 263882790666240
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    storageAccountType: 'GRS'
    provisioningState: 'Succeeded'
  }
}

resource Microsoft_Synapse_workspaces_vulnerabilityAssessments_workspaces_synd92txe0r_name_Default 'Microsoft.Synapse/workspaces/vulnerabilityAssessments@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_resource
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath
  }
}

resource storageAccounts_stjdj4ltxv_name_default_synapsefs 'Microsoft.Storage/storageAccounts/blobServices/containers@2026-04-01' = {
  parent: storageAccounts_stjdj4ltxv_name_default
  name: 'synapsefs'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_stjdj4ltxv_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_Default 'Microsoft.Synapse/workspaces/sqlPools/auditingSettings@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_extendedAuditingSettings_workspaces_synd92txe0r_name_sqlpool1_Default 'Microsoft.Synapse/workspaces/sqlPools/extendedAuditingSettings@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_geoBackupPolicies_workspaces_synd92txe0r_name_sqlpool1_Default 'Microsoft.Synapse/workspaces/sqlPools/geoBackupPolicies@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'Default'
  location: 'Sweden Central'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_securityAlertPolicies_workspaces_synd92txe0r_name_sqlpool1_Default 'Microsoft.Synapse/workspaces/sqlPools/securityAlertPolicies@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'Default'
  properties: {
    state: 'Disabled'
    disabledAlerts: [
      ''
    ]
    emailAddresses: [
      ''
    ]
    emailAccountAdmins: false
    retentionDays: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_current 'Microsoft.Synapse/workspaces/sqlPools/transparentDataEncryption@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'current'
  location: 'Sweden Central'
  properties: {
    status: 'Disabled'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource Microsoft_Synapse_workspaces_sqlPools_vulnerabilityAssessments_workspaces_synd92txe0r_name_sqlpool1_Default 'Microsoft.Synapse/workspaces/sqlPools/vulnerabilityAssessments@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_largerc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'largerc'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('22')
    maxResourcePercentPerRequest: json('22')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_mediumrc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'mediumrc'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('10')
    maxResourcePercentPerRequest: json('10')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_smallrc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'smallrc'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('3')
    maxResourcePercentPerRequest: json('3')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc10 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc10'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('0.4')
    maxResourcePercentPerRequest: json('0.4')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc20 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc20'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('0.8')
    maxResourcePercentPerRequest: json('0.8')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc30 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc30'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('1.6')
    maxResourcePercentPerRequest: json('1.6')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc40 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc40'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('3.2')
    maxResourcePercentPerRequest: json('3.2')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc50 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc50'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('6.4')
    maxResourcePercentPerRequest: json('6.4')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc60 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc60'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('12.8')
    maxResourcePercentPerRequest: json('12.8')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc70 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc70'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('25.6')
    maxResourcePercentPerRequest: json('25.6')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc80 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'staticrc80'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('51.2')
    maxResourcePercentPerRequest: json('51.2')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_xlargerc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1
  name: 'xlargerc'
  properties: {
    minResourcePercent: 0
    maxResourcePercent: 100
    minResourcePercentPerRequest: json('70')
    maxResourcePercentPerRequest: json('70')
    importance: 'normal'
    queryExecutionTimeout: 0
  }
  dependsOn: [
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_largerc_largerc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_largerc
  name: 'largerc'
  properties: {
    memberName: 'largerc'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_mediumrc_mediumrc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_mediumrc
  name: 'mediumrc'
  properties: {
    memberName: 'mediumrc'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_smallrc_smallrc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_smallrc
  name: 'smallrc'
  properties: {
    memberName: 'smallrc'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc10_staticrc10 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc10
  name: 'staticrc10'
  properties: {
    memberName: 'staticrc10'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc20_staticrc20 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc20
  name: 'staticrc20'
  properties: {
    memberName: 'staticrc20'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc30_staticrc30 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc30
  name: 'staticrc30'
  properties: {
    memberName: 'staticrc30'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc40_staticrc40 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc40
  name: 'staticrc40'
  properties: {
    memberName: 'staticrc40'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc50_staticrc50 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc50
  name: 'staticrc50'
  properties: {
    memberName: 'staticrc50'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc60_staticrc60 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc60
  name: 'staticrc60'
  properties: {
    memberName: 'staticrc60'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc70_staticrc70 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc70
  name: 'staticrc70'
  properties: {
    memberName: 'staticrc70'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_staticrc80_staticrc80 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_staticrc80
  name: 'staticrc80'
  properties: {
    memberName: 'staticrc80'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}

resource workspaces_synd92txe0r_name_sqlpool1_xlargerc_xlargerc 'Microsoft.Synapse/workspaces/sqlPools/workloadGroups/workloadClassifiers@2021-06-01' = {
  parent: workspaces_synd92txe0r_name_sqlpool1_xlargerc
  name: 'xlargerc'
  properties: {
    memberName: 'xlargerc'
    importance: 'normal'
  }
  dependsOn: [
    workspaces_synd92txe0r_name_sqlpool1
    workspaces_synd92txe0r_name_resource
  ]
}


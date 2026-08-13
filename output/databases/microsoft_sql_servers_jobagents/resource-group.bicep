@secure()
param vulnerabilityAssessments_Default_storageContainerPath string
param servers_sqltcfi_k_s_name string

resource servers_sqltcfi_k_s_name_resource 'Microsoft.Sql/servers@2025-02-01-preview' = {
  name: servers_sqltcfi_k_s_name
  location: 'swedencentral'
  kind: 'v12.0'
  properties: {
    administratorLogin: 'azrddadmin'
    version: '12.0'
    minimalTlsVersion: '1.2'
    publicNetworkAccess: 'Enabled'
    restrictOutboundNetworkAccess: 'Disabled'
    retentionDays: -1
  }
}

resource servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/advancedThreatProtectionSettings@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource servers_sqltcfi_k_s_name_CreateIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sqltcfi_k_s_name_DbParameterization 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sqltcfi_k_s_name_DefragmentIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sqltcfi_k_s_name_DropIndex 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
}

resource servers_sqltcfi_k_s_name_ForceLastGoodPlan 'Microsoft.Sql/servers/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
}

resource Microsoft_Sql_servers_auditingPolicies_servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/auditingPolicies@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'Default'
  location: 'Sweden Central'
  properties: {
    auditingState: 'Disabled'
  }
}

resource Microsoft_Sql_servers_auditingSettings_servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/auditingSettings@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource Microsoft_Sql_servers_connectionPolicies_servers_sqltcfi_k_s_name_default 'Microsoft.Sql/servers/connectionPolicies@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'default'
  location: 'swedencentral'
  properties: {
    connectionType: 'Default'
  }
}

resource servers_sqltcfi_k_s_name_jobagentdb 'Microsoft.Sql/servers/databases@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'jobagentdb'
  location: 'swedencentral'
  sku: {
    name: 'S0'
    tier: 'Standard'
    capacity: 10
  }
  kind: 'v12.0,user'
  properties: {
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    maxSizeBytes: 268435456000
    catalogCollation: 'SQL_Latin1_General_CP1_CI_AS'
    zoneRedundant: false
    readScale: 'Disabled'
    requestedBackupStorageRedundancy: 'Geo'
    maintenanceConfigurationId: '/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Maintenance/publicMaintenanceConfigurations/SQL_Default'
    isLedgerOn: false
    availabilityZone: 'NoPreference'
  }
}

resource servers_sqltcfi_k_s_name_master_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_sqltcfi_k_s_name_master_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  name: '${servers_sqltcfi_k_s_name}/master/Default'
  location: 'Sweden Central'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_sqltcfi_k_s_name_master_Default 'Microsoft.Sql/servers/databases/auditingSettings@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_sqltcfi_k_s_name_master_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_sqltcfi_k_s_name_master_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Default'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_master_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Current'
  properties: {}
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_sqltcfi_k_s_name_master_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Default'
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
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_sqltcfi_k_s_name_master_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Current'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_sqltcfi_k_s_name_master_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2025-02-01-preview' = {
  name: '${servers_sqltcfi_k_s_name}/master/Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_devOpsAuditingSettings_servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/devOpsAuditingSettings@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'Default'
  properties: {
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_sqltcfi_k_s_name_current 'Microsoft.Sql/servers/encryptionProtector@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'current'
  kind: 'servicemanaged'
  properties: {
    serverKeyName: 'ServiceManaged'
    serverKeyType: 'ServiceManaged'
    autoRotationEnabled: false
  }
}

resource Microsoft_Sql_servers_extendedAuditingSettings_servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/extendedAuditingSettings@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'Default'
  properties: {
    retentionDays: 0
    auditActionsAndGroups: []
    isStorageSecondaryKeyInUse: false
    isAzureMonitorTargetEnabled: false
    isManagedIdentityInUse: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
}

resource servers_sqltcfi_k_s_name_ServiceManaged 'Microsoft.Sql/servers/keys@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'ServiceManaged'
  kind: 'servicemanaged'
  properties: {
    serverKeyType: 'ServiceManaged'
  }
}

resource Microsoft_Sql_servers_securityAlertPolicies_servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/securityAlertPolicies@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
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

resource Microsoft_Sql_servers_sqlVulnerabilityAssessments_servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/sqlVulnerabilityAssessments@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}

resource Microsoft_Sql_servers_vulnerabilityAssessments_servers_sqltcfi_k_s_name_Default 'Microsoft.Sql/servers/vulnerabilityAssessments@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
    storageContainerPath: vulnerabilityAssessments_Default_storageContainerPath
  }
}

resource servers_sqltcfi_k_s_name_jobagentdb_Default 'Microsoft.Sql/servers/databases/advancedThreatProtectionSettings@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_jobagentdb_CreateIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'CreateIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_jobagentdb_DbParameterization 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'DbParameterization'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_jobagentdb_DefragmentIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'DefragmentIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_jobagentdb_DropIndex 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'DropIndex'
  properties: {
    autoExecuteValue: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_jobagentdb_ForceLastGoodPlan 'Microsoft.Sql/servers/databases/advisors@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'ForceLastGoodPlan'
  properties: {
    autoExecuteValue: 'Enabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingPolicies_servers_sqltcfi_k_s_name_jobagentdb_Default 'Microsoft.Sql/servers/databases/auditingPolicies@2014-04-01' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Default'
  location: 'Sweden Central'
  properties: {
    auditingState: 'Disabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_auditingSettings_servers_sqltcfi_k_s_name_jobagentdb_Default 'Microsoft.Sql/servers/databases/auditingSettings@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupLongTermRetentionPolicies_servers_sqltcfi_k_s_name_jobagentdb_default 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'default'
  properties: {
    timeBasedImmutability: 'Disabled'
    weeklyRetention: 'PT0S'
    monthlyRetention: 'PT0S'
    yearlyRetention: 'PT0S'
    weekOfYear: 0
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_backupShortTermRetentionPolicies_servers_sqltcfi_k_s_name_jobagentdb_default 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'default'
  properties: {
    retentionDays: 7
    diffBackupIntervalInHours: 24
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_extendedAuditingSettings_servers_sqltcfi_k_s_name_jobagentdb_Default 'Microsoft.Sql/servers/databases/extendedAuditingSettings@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Default'
  properties: {
    retentionDays: 0
    isAzureMonitorTargetEnabled: false
    state: 'Disabled'
    storageAccountSubscriptionId: '00000000-0000-0000-0000-000000000000'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_geoBackupPolicies_servers_sqltcfi_k_s_name_jobagentdb_Default 'Microsoft.Sql/servers/databases/geoBackupPolicies@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Default'
  properties: {
    state: 'Enabled'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_jobagentdb_Current 'Microsoft.Sql/servers/databases/ledgerDigestUploads@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Current'
  properties: {}
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_securityAlertPolicies_servers_sqltcfi_k_s_name_jobagentdb_Default 'Microsoft.Sql/servers/databases/securityAlertPolicies@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
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
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_transparentDataEncryption_servers_sqltcfi_k_s_name_jobagentdb_Current 'Microsoft.Sql/servers/databases/transparentDataEncryption@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Current'
  properties: {
    state: 'Enabled'
    scanState: 'Complete'
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource Microsoft_Sql_servers_databases_vulnerabilityAssessments_servers_sqltcfi_k_s_name_jobagentdb_Default 'Microsoft.Sql/servers/databases/vulnerabilityAssessments@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_jobagentdb
  name: 'Default'
  properties: {
    recurringScans: {
      isEnabled: false
      emailSubscriptionAdmins: true
    }
  }
  dependsOn: [
    servers_sqltcfi_k_s_name_resource
  ]
}

resource servers_sqltcfi_k_s_name_jobagentfwj1t3 'Microsoft.Sql/servers/jobAgents@2025-02-01-preview' = {
  parent: servers_sqltcfi_k_s_name_resource
  name: 'jobagentfwj1t3'
  location: 'swedencentral'
  sku: {
    name: 'JA100'
    capacity: 100
  }
  properties: {
    databaseId: servers_sqltcfi_k_s_name_jobagentdb.id
  }
}


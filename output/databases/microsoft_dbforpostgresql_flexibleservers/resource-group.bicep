param flexibleServers_pgfd6vwwi6_name string

resource flexibleServers_pgfd6vwwi6_name_resource 'Microsoft.DBforPostgreSQL/flexibleServers@2026-04-01-preview' = {
  name: flexibleServers_pgfd6vwwi6_name
  location: 'West Europe'
  sku: {
    name: 'Standard_B1ms'
    tier: 'Burstable'
  }
  properties: {
    dataEncryption: {
      type: 'SystemManaged'
    }
    replica: {
      role: 'Primary'
    }
    storage: {
      type: 'Premium_LRS'
      iops: 120
      tier: 'P4'
      storageSizeGB: 32
      autoGrow: 'Disabled'
    }
    network: {
      publicNetworkAccess: 'Enabled'
    }
    authConfig: {
      activeDirectoryAuth: 'Disabled'
      passwordAuth: 'Enabled'
    }
    version: '16'
    administratorLogin: 'azrddadmin'
    availabilityZone: '2'
    backup: {
      backupRetentionDays: 7
      geoRedundantBackup: 'Disabled'
    }
    highAvailability: {
      mode: 'Disabled'
    }
    maintenanceWindow: {
      customWindow: 'Disabled'
      dayOfWeek: 0
      startHour: 0
      startMinute: 0
    }
    replicationRole: 'Primary'
  }
}

resource flexibleServers_pgfd6vwwi6_name_Default 'Microsoft.DBforPostgreSQL/flexibleServers/advancedThreatProtectionSettings@2026-04-01-preview' = {
  parent: flexibleServers_pgfd6vwwi6_name_resource
  name: 'Default'
  properties: {
    state: 'Disabled'
  }
}


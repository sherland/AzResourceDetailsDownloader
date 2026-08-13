param disks_diskflr4a67c_name string
param snapshots_snapshnmog8v_name string

resource disks_diskflr4a67c_name_resource 'Microsoft.Compute/disks@2025-01-02' = {
  name: disks_diskflr4a67c_name
  location: 'norwayeast'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    creationData: {
      createOption: 'Empty'
    }
    diskSizeGB: 4
    diskIOPSReadWrite: 500
    diskMBpsReadWrite: 60
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
    networkAccessPolicy: 'AllowAll'
    publicNetworkAccess: 'Enabled'
  }
}

resource snapshots_snapshnmog8v_name_resource 'Microsoft.Compute/snapshots@2025-01-02' = {
  name: snapshots_snapshnmog8v_name
  location: 'norwayeast'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    creationData: {
      createOption: 'Copy'
      sourceResourceId: disks_diskflr4a67c_name_resource.id
    }
    diskSizeGB: 4
    encryption: {
      type: 'EncryptionAtRestWithPlatformKey'
    }
    incremental: false
    networkAccessPolicy: 'AllowAll'
    publicNetworkAccess: 'Enabled'
  }
}


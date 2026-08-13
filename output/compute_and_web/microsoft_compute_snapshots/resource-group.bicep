param disks_diskgxpe04sm_name string
param snapshots_snapw3td1qq0_name string

resource disks_diskgxpe04sm_name_resource 'Microsoft.Compute/disks@2025-01-02' = {
  name: disks_diskgxpe04sm_name
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

resource snapshots_snapw3td1qq0_name_resource 'Microsoft.Compute/snapshots@2025-01-02' = {
  name: snapshots_snapw3td1qq0_name
  location: 'norwayeast'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    creationData: {
      createOption: 'Copy'
      sourceResourceId: disks_diskgxpe04sm_name_resource.id
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


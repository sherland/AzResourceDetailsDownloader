param disks_diskmrvds8oj_name string
param snapshots_snap48glwc3z_name string

resource disks_diskmrvds8oj_name_resource 'Microsoft.Compute/disks@2025-01-02' = {
  name: disks_diskmrvds8oj_name
  location: 'norwayeast'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    osType: 'Linux'
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

resource snapshots_snap48glwc3z_name_resource 'Microsoft.Compute/snapshots@2025-01-02' = {
  name: snapshots_snap48glwc3z_name
  location: 'norwayeast'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    osType: 'Linux'
    creationData: {
      createOption: 'Copy'
      sourceResourceId: disks_diskmrvds8oj_name_resource.id
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


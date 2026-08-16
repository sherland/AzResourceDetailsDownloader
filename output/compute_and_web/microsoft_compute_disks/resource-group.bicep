param disks_diskbpe8_oy2_name string

resource disks_diskbpe8_oy2_name_resource 'Microsoft.Compute/disks@2025-01-02' = {
  name: disks_diskbpe8_oy2_name
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


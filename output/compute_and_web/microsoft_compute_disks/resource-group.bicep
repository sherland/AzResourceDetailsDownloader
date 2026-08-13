param disks_disk4_94_a_6_name string

resource disks_disk4_94_a_6_name_resource 'Microsoft.Compute/disks@2025-01-02' = {
  name: disks_disk4_94_a_6_name
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


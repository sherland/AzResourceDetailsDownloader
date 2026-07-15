param mongoClusters_mc7id9mtlp_name string

resource mongoClusters_mc7id9mtlp_name_resource 'Microsoft.DocumentDB/mongoClusters@2026-02-01-preview' = {
  name: mongoClusters_mc7id9mtlp_name
  location: 'westeurope'
  identity: {
    type: 'None'
  }
  properties: {
    administrator: {
      userName: 'azrddadmin'
    }
    serverVersion: '7.0'
    compute: {
      tier: 'M10'
    }
    storage: {
      sizeGb: 32
      type: 'PremiumSSD'
    }
    sharding: {
      shardCount: 1
    }
    highAvailability: {
      targetMode: 'Disabled'
    }
    backup: {}
    publicNetworkAccess: 'Enabled'
    dataApi: {
      mode: 'Disabled'
    }
    authConfig: {
      allowedModes: [
        'NativeAuth'
      ]
    }
    createMode: 'Default'
    networkBypassMode: 'None'
  }
}

resource mongoClusters_mc7id9mtlp_name_azrddadmin 'Microsoft.DocumentDB/mongoClusters/users@2026-02-01-preview' = {
  parent: mongoClusters_mc7id9mtlp_name_resource
  name: 'azrddadmin'
  properties: {}
}


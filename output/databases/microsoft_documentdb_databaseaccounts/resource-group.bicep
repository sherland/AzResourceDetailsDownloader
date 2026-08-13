param databaseAccounts_cosmosd5q1iefd_name string

resource databaseAccounts_cosmosd5q1iefd_name_resource 'Microsoft.DocumentDB/databaseAccounts@2026-04-01-preview' = {
  name: databaseAccounts_cosmosd5q1iefd_name
  location: 'Sweden Central'
  kind: 'GlobalDocumentDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: true
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'WellDefined'
    }
    databaseAccountOfferType: 'Standard'
    enableMaterializedViews: false
    capacityMode: 'Serverless'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    enablePartitionMerge: false
    enablePerRegionPerPartitionAutoscale: false
    enableBurstCapacity: false
    enablePriorityBasedExecution: false
    defaultPriorityLevel: 'High'
    minimalTlsVersion: 'Tls12'
    enforceHierarchicalPartitionKeyIdLastLevel: false
    softDeleteConfiguration: {
      softDeletionEnabled: false
      minMinutesBeforePermanentDeletionAllowed: -1
      softDeleteRetentionPeriodInMinutes: -1
    }
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    locations: [
      {
        locationName: 'Sweden Central'
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: []
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    diagnosticLogSettings: {
      enableFullTextQuery: 'None'
    }
  }
}

resource databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000003 'Microsoft.DocumentDB/databaseAccounts/cassandraRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000003'
  properties: {
    roleName: 'Cosmos DB Cassandra Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000004 'Microsoft.DocumentDB/databaseAccounts/cassandraRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000004'
  properties: {
    roleName: 'Cosmos DB Cassandra Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/write'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/*'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/write'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/delete'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/cassandra/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_gremlinRoleDefinitions_databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000003 'Microsoft.DocumentDB/databaseAccounts/gremlinRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000003'
  properties: {
    roleName: 'Cosmos DB Gremlin Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_gremlinRoleDefinitions_databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000004 'Microsoft.DocumentDB/databaseAccounts/gremlinRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000004'
  properties: {
    roleName: 'Cosmos DB Gremlin Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/write'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/*'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/write'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/delete'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/gremlin/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_mongoMIRoleDefinitions_databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000003 'Microsoft.DocumentDB/databaseAccounts/mongoMIRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000003'
  properties: {
    roleName: 'Cosmos DB Mongo Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_mongoMIRoleDefinitions_databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000004 'Microsoft.DocumentDB/databaseAccounts/mongoMIRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000004'
  properties: {
    roleName: 'Cosmos DB Mongo Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/read'
          'Microsoft.DocumentDB/databaseAccounts/throughputSettings/write'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/*'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/write'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/delete'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/mongoMI/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_tableRoleDefinitions_databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000001 'Microsoft.DocumentDB/databaseAccounts/tableRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000001'
  properties: {
    roleName: 'Cosmos DB Built-in Data Reader'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/executeQuery'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/readChangeFeed'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/entities/read'
        ]
        notDataActions: []
      }
    ]
  }
}

resource Microsoft_DocumentDB_databaseAccounts_tableRoleDefinitions_databaseAccounts_cosmosd5q1iefd_name_00000000_0000_0000_0000_000000000002 'Microsoft.DocumentDB/databaseAccounts/tableRoleDefinitions@2026-04-01-preview' = {
  parent: databaseAccounts_cosmosd5q1iefd_name_resource
  name: '00000000-0000-0000-0000-000000000002'
  properties: {
    roleName: 'Cosmos DB Built-in Data Contributor'
    type: 'BuiltInRole'
    assignableScopes: [
      databaseAccounts_cosmosd5q1iefd_name_resource.id
    ]
    permissions: [
      {
        dataActions: [
          'Microsoft.DocumentDB/databaseAccounts/readMetadata'
          'Microsoft.DocumentDB/databaseAccounts/tables/*'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/*'
          'Microsoft.DocumentDB/databaseAccounts/tables/containers/entities/*'
        ]
        notDataActions: []
      }
    ]
  }
}


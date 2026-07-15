@secure()
param IotHubs_iot19ncaw4p_connectionString string

@secure()
param IotHubs_iot19ncaw4p_containerName string
param IotHubs_iot19ncaw4p_name string

resource IotHubs_iot19ncaw4p_name_resource 'Microsoft.Devices/IotHubs@2025-08-01-preview' = {
  name: IotHubs_iot19ncaw4p_name
  location: 'westeurope'
  sku: {
    name: 'F1'
    tier: 'Free'
    capacity: 1
  }
  identity: {
    type: 'None'
  }
  properties: {
    ipFilterRules: []
    eventHubEndpoints: {
      events: {
        retentionTimeInDays: 1
        partitionCount: 2
      }
    }
    routing: {
      endpoints: {
        serviceBusQueues: []
        serviceBusTopics: []
        eventHubs: []
        storageContainers: []
        cosmosDBSqlContainers: []
      }
      routes: []
      fallbackRoute: {
        name: '$fallback'
        source: 'DeviceMessages'
        condition: 'true'
        endpointNames: [
          'events'
        ]
        isEnabled: true
      }
    }
    storageEndpoints: {
      '$default': {
        sasTtlAsIso8601: 'PT1H'
        connectionString: IotHubs_iot19ncaw4p_connectionString
        containerName: IotHubs_iot19ncaw4p_containerName
      }
    }
    messagingEndpoints: {
      fileNotifications: {
        lockDurationAsIso8601: 'PT1M'
        ttlAsIso8601: 'PT1H'
        maxDeliveryCount: 10
      }
    }
    enableFileUploadNotifications: false
    cloudToDevice: {
      maxDeliveryCount: 10
      defaultTtlAsIso8601: 'PT1H'
      feedback: {
        lockDurationAsIso8601: 'PT1M'
        ttlAsIso8601: 'PT1H'
        maxDeliveryCount: 10
      }
    }
    features: 'RootCertificateV2'
    minTlsVersion: '1.2'
    allowedFqdnList: []
    rootCertificate: {
      enableRootCertificateV2: true
    }
  }
}


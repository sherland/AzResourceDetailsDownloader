param containerGroups_acitk_i_5_3_name string

resource containerGroups_acitk_i_5_3_name_resource 'Microsoft.ContainerInstance/containerGroups@2025-09-01' = {
  name: containerGroups_acitk_i_5_3_name
  location: 'norwayeast'
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: 'main'
        properties: {
          image: 'mcr.microsoft.com/azuredocs/aci-helloworld'
          ports: []
          environmentVariables: []
          configMap: {
            keyValuePairs: {}
          }
          resources: {
            requests: {
              memoryInGB: json('1')
              cpu: json('1')
            }
          }
        }
      }
    ]
    initContainers: []
    restartPolicy: 'Never'
    osType: 'Linux'
  }
}


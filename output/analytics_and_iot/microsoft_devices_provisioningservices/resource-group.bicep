param provisioningServices_dpsu79_smow_name string

resource provisioningServices_dpsu79_smow_name_resource 'Microsoft.Devices/provisioningServices@2025-02-01-preview' = {
  name: provisioningServices_dpsu79_smow_name
  location: 'northeurope'
  sku: {
    name: 'S1'
    tier: 'Standard'
    capacity: 1
  }
  identity: {
    type: 'None'
  }
  properties: {
    state: 'Active'
    provisioningState: 'Succeeded'
    iotHubs: []
    allocationPolicy: 'Hashed'
    portalOperationsHostName: '${provisioningServices_dpsu79_smow_name}.services.azure-devices-provisioning.net'
  }
}


param loadTests_ltft68qr_q_name string

resource loadTests_ltft68qr_q_name_resource 'Microsoft.LoadTestService/loadTests@2024-12-01-preview' = {
  name: loadTests_ltft68qr_q_name
  location: 'westeurope'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    description: 'ARDL load test resource'
  }
}


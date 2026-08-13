param serviceEndpointPolicies_sepaibfiwep_name string

resource serviceEndpointPolicies_sepaibfiwep_name_resource 'Microsoft.Network/serviceEndpointPolicies@2025-07-01' = {
  name: serviceEndpointPolicies_sepaibfiwep_name
  location: 'norwayeast'
  properties: {
    serviceEndpointPolicyDefinitions: []
  }
}


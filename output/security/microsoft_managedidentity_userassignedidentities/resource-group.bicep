param userAssignedIdentities_id9smfdnx8_name string

resource userAssignedIdentities_id9smfdnx8_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-05-31-preview' = {
  name: userAssignedIdentities_id9smfdnx8_name
  location: 'westeurope'
  properties: {
    isolationScope: 'None'
    assignmentRestrictions: {
      providers: []
    }
  }
}


param userAssignedIdentities_idntomdsx0_name string

resource userAssignedIdentities_idntomdsx0_name_resource 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-05-31-preview' = {
  name: userAssignedIdentities_idntomdsx0_name
  location: 'norwayeast'
  properties: {
    isolationScope: 'None'
    assignmentRestrictions: {
      providers: []
    }
  }
}


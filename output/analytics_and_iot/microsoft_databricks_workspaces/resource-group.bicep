param workspaces_dbx21a20_w4_name string

resource workspaces_dbx21a20_w4_name_resource 'Microsoft.Databricks/workspaces@2026-01-01' = {
  name: workspaces_dbx21a20_w4_name
  location: 'norwayeast'
  sku: {
    name: 'premium'
  }
  properties: {
    computeMode: 'Hybrid'
    managedResourceGroupId: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/ardl-dbx-managed-xm1ddvc7'
    parameters: {
      enableNoPublicIp: {
        type: 'Bool'
        value: true
      }
      prepareEncryption: {
        type: 'Bool'
        value: false
      }
      requireInfrastructureEncryption: {
        type: 'Bool'
        value: false
      }
      storageAccountName: {
        type: 'String'
        value: 'dbstoragevpqsauyrlthy4'
      }
      storageAccountSkuName: {
        type: 'String'
        value: 'Standard_ZRS'
      }
    }
    authorizations: [
      {
        principalId: '9a74af6f-d153-4348-988a-e2672920bee9'
        roleDefinitionId: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
      }
    ]
    createdBy: {}
    updatedBy: {}
  }
}


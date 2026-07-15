param proximityPlacementGroups_ppga5vrkskv_name string

resource proximityPlacementGroups_ppga5vrkskv_name_resource 'Microsoft.Compute/proximityPlacementGroups@2025-11-01' = {
  name: proximityPlacementGroups_ppga5vrkskv_name
  location: 'westeurope'
  properties: {
    proximityPlacementGroupType: 'Standard'
  }
}


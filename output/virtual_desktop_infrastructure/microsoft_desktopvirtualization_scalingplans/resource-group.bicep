param scalingplans_avdspc4cwd2_4_name string

resource scalingplans_avdspc4cwd2_4_name_resource 'Microsoft.DesktopVirtualization/scalingplans@2026-03-01-preview' = {
  name: scalingplans_avdspc4cwd2_4_name
  location: 'northeurope'
  properties: {
    timeZone: 'UTC'
    hostPoolType: 'Pooled'
    schedules: []
    hostPoolReferences: []
  }
}


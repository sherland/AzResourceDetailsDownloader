param assessmentProjects_migprojjd7_v5em_name string

resource assessmentProjects_migprojjd7_v5em_name_resource 'Microsoft.Migrate/assessmentProjects@2024-03-03-preview' = {
  name: assessmentProjects_migprojjd7_v5em_name
  location: 'norwayeast'
  properties: {
    publicNetworkAccess: 'Enabled'
    projectStatus: 'Active'
  }
}


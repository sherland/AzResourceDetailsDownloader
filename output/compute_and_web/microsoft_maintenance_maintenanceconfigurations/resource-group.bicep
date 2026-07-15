param maintenanceconfigurations_mclpeogsoh_name string

resource maintenanceconfigurations_mclpeogsoh_name_resource 'microsoft.maintenance/maintenanceconfigurations@2023-10-01-preview' = {
  name: maintenanceconfigurations_mclpeogsoh_name
  location: 'westeurope'
  properties: {
    extensionProperties: {
      InGuestPatchMode: 'User'
    }
    maintenanceScope: 'InGuestPatch'
    maintenanceWindow: {
      startDateTime: '2030-01-01 00:00'
      duration: '03:00'
      timeZone: 'UTC'
      recurEvery: '1Day'
    }
    visibility: 'Custom'
    installPatches: {
      rebootSetting: 'IfRequired'
      windowsParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
      linuxParameters: {
        classificationsToInclude: [
          'Critical'
          'Security'
        ]
      }
    }
  }
}


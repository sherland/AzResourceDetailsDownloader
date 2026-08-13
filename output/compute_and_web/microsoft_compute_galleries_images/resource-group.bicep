param galleries_gals0yvwobz_name string

resource galleries_gals0yvwobz_name_resource 'Microsoft.Compute/galleries@2025-03-03' = {
  name: galleries_gals0yvwobz_name
  location: 'norwayeast'
  properties: {
    identifier: {}
  }
}

resource galleries_gals0yvwobz_name_imgyoclcp 'Microsoft.Compute/galleries/images@2025-03-03' = {
  parent: galleries_gals0yvwobz_name_resource
  name: 'imgyoclcp'
  location: 'norwayeast'
  properties: {
    hyperVGeneration: 'V1'
    architecture: 'x64'
    osType: 'Linux'
    osState: 'Generalized'
    identifier: {
      publisher: 'ardl'
      offer: 'ardl-offer'
      sku: 'ardl-sku'
    }
  }
}


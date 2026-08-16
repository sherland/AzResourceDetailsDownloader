param galleries_galor6b8wuj_name string

resource galleries_galor6b8wuj_name_resource 'Microsoft.Compute/galleries@2025-03-03' = {
  name: galleries_galor6b8wuj_name
  location: 'norwayeast'
  properties: {
    identifier: {}
  }
}

resource galleries_galor6b8wuj_name_imgjq43aq 'Microsoft.Compute/galleries/images@2025-03-03' = {
  parent: galleries_galor6b8wuj_name_resource
  name: 'imgjq43aq'
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


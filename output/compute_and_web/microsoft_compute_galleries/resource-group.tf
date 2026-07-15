terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.66.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "res-0" {
  location   = "westeurope"
  managed_by = ""
  name       = "rg-ardl-17ad0172a1b3435d"
  tags = {
    armType    = "Microsoft.Compute/galleries"
    createdUtc = "2026-07-15T09:20:21.2878297Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_shared_image_gallery" "res-1" {
  description         = ""
  location            = "westeurope"
  name                = "galm6i0e2dh"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-17ad0172a1b3435d"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-17ad0172a1b3435d/providers/Microsoft.Compute/galleries/galm6i0e2dh"
  to = azurerm_shared_image_gallery.res-1
}

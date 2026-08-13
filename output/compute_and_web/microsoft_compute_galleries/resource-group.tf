terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.80.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "res-0" {
  location   = "norwayeast"
  managed_by = ""
  name       = "rg-ardl-17ad0172a1b3435d"
  tags = {
    armType    = "Microsoft.Compute/galleries"
    createdUtc = "2026-08-13T12:52:54.9821450Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_shared_image_gallery" "res-1" {
  description         = ""
  location            = "norwayeast"
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

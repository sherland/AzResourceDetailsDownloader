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
  name       = "rg-ardl-faf37f47d84dab3a"
  tags = {
    armType    = "Microsoft.Compute/proximityPlacementGroups"
    createdUtc = "2026-08-13T13:24:54.2753456Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_proximity_placement_group" "res-1" {
  allowed_vm_sizes    = []
  location            = "norwayeast"
  name                = "ppga5vrkskv"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  zone                = ""
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-faf37f47d84dab3a"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-faf37f47d84dab3a/providers/Microsoft.Compute/proximityPlacementGroups/ppga5vrkskv"
  to = azurerm_proximity_placement_group.res-1
}

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
  name       = "rg-ardl-ea290fed5655d3db"
  tags = {
    armType    = "Microsoft.Devices/provisioningServices"
    createdUtc = "2026-08-13T14:15:54.5681806Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_iothub_dps" "res-1" {
  allocation_policy             = "Hashed"
  data_residency_enabled        = false
  location                      = "northeurope"
  name                          = "dpsu79-smow"
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = {}
  sku {
    capacity = 1
    name     = "S1"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ea290fed5655d3db"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ea290fed5655d3db/providers/Microsoft.Devices/provisioningServices/dpsu79-smow"
  to = azurerm_iothub_dps.res-1
}

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
  name       = "rg-ardl-27116b321f34dc32"
  tags = {
    armType    = "Microsoft.Compute/availabilitySets"
    createdUtc = "2026-08-16T13:31:55.2615934Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_availability_set" "res-1" {
  location                     = "norwayeast"
  managed                      = true
  name                         = "avset6-0q-nt0"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  resource_group_name          = azurerm_resource_group.res-0.name
  tags                         = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-27116b321f34dc32"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-27116b321f34dc32/providers/Microsoft.Compute/availabilitySets/avset6-0q-nt0"
  to = azurerm_availability_set.res-1
}

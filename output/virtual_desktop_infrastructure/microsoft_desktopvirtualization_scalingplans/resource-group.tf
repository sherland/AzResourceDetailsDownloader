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
  name       = "rg-ardl-ec59d008cf062ae8"
  tags = {
    armType    = "Microsoft.DesktopVirtualization/scalingPlans"
    createdUtc = "2026-07-15T19:22:53.1046964Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_desktop_scaling_plan" "res-1" {
  description         = ""
  exclusion_tag       = ""
  friendly_name       = ""
  location            = "westeurope"
  name                = "avdspc4cwd2-4"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  time_zone           = "UTC"
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ec59d008cf062ae8"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ec59d008cf062ae8/providers/Microsoft.DesktopVirtualization/scalingPlans/avdspc4cwd2-4"
  to = azurerm_virtual_desktop_scaling_plan.res-1
}

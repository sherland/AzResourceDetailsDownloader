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
  name       = "rg-ardl-6a40d03fb53e43c5"
  tags = {
    armType    = "Microsoft.Portal/dashboards"
    createdUtc = "2026-07-15T11:15:55.7829158Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_portal_dashboard" "res-1" {
  dashboard_properties = jsonencode({
    lenses = {}
  })
  location            = "westeurope"
  name                = "dashm4vvt9ry"
  resource_group_name = azurerm_resource_group.res-0.name
  tags = {
    hidden-title = "ARDL Dashboard"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6a40d03fb53e43c5"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6a40d03fb53e43c5/providers/Microsoft.Portal/dashboards/dashm4vvt9ry"
  to = azurerm_portal_dashboard.res-1
}

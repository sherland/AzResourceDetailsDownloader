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
  name       = "rg-ardl-1fe5141e0d0dffeb"
  tags = {
    armType    = "Microsoft.OperationalInsights/querypacks"
    createdUtc = "2026-07-15T09:18:39.8537793Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_log_analytics_query_pack" "res-1" {
  location            = "westeurope"
  name                = "qpdn2pzyb4"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1fe5141e0d0dffeb"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1fe5141e0d0dffeb/providers/Microsoft.OperationalInsights/queryPacks/qpdn2pzyb4"
  to = azurerm_log_analytics_query_pack.res-1
}

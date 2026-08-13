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
  name       = "rg-ardl-1fe5141e0d0dffeb"
  tags = {
    armType    = "Microsoft.OperationalInsights/querypacks"
    createdUtc = "2026-08-13T12:51:58.8109068Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_log_analytics_query_pack" "res-1" {
  location            = "norwayeast"
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

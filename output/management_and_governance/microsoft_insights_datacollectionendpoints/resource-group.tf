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
  name       = "rg-ardl-f7a06090e7544e58"
  tags = {
    armType    = "Microsoft.Insights/dataCollectionEndpoints"
    createdUtc = "2026-08-16T13:55:04.6011656Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_monitor_data_collection_endpoint" "res-1" {
  description                   = ""
  kind                          = ""
  location                      = "norwayeast"
  name                          = "dcemegmb-xy"
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  tags                          = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-f7a06090e7544e58"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-f7a06090e7544e58/providers/Microsoft.Insights/dataCollectionEndpoints/dcemegmb-xy"
  to = azurerm_monitor_data_collection_endpoint.res-1
}

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
  name       = "rg-ardl-523affa83da0c585"
  tags = {
    armType    = "Microsoft.NotificationHubs/namespaces"
    createdUtc = "2026-07-15T09:28:16.6352896Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_notification_hub_namespace" "res-1" {
  enabled                 = true
  location                = "westeurope"
  name                    = "nhnsfb-y-5-5"
  replication_region      = "default"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku_name                = "Free"
  tags                    = {}
  zone_redundancy_enabled = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-523affa83da0c585"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-523affa83da0c585/providers/Microsoft.NotificationHubs/namespaces/nhnsfb-y-5-5"
  to = azurerm_notification_hub_namespace.res-1
}

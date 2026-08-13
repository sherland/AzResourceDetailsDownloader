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
  name       = "rg-ardl-523affa83da0c585"
  tags = {
    armType    = "Microsoft.NotificationHubs/namespaces"
    createdUtc = "2026-08-13T12:59:21.1682390Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_notification_hub_namespace" "res-1" {
  enabled                 = true
  location                = "norwayeast"
  name                    = "nhnsfb-y-5-5"
  replication_region      = "default"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku_name                = "Free"
  tags                    = {}
  zone_redundancy_enabled = true
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-523affa83da0c585"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-523affa83da0c585/providers/Microsoft.NotificationHubs/namespaces/nhnsfb-y-5-5"
  to = azurerm_notification_hub_namespace.res-1
}

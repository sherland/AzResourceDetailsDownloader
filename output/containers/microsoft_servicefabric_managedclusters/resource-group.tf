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
  name       = "rg-ardl-a157244b5485ef94"
  tags = {
    armType    = "Microsoft.ServiceFabric/managedClusters"
    createdUtc = "2026-08-13T13:36:50.7455445Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_service_fabric_managed_cluster" "res-1" {
  backup_service_enabled = false
  client_connection_port = 19000
  dns_name               = "ardlsfmc0c-f-h"
  dns_service_enabled    = false
  http_gateway_port      = 19080
  location               = "norwayeast"
  name                   = "sfmc9-v2v-ub"
  password               = "" # Masked sensitive attribute
  resource_group_name    = azurerm_resource_group.res-0.name
  sku                    = "Basic"
  subnet_id              = ""
  tags                   = {}
  upgrade_wave           = "Wave0"
  username               = "azrddadmin"
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a157244b5485ef94"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-a157244b5485ef94/providers/Microsoft.ServiceFabric/managedClusters/sfmc9-v2v-ub"
  to = azurerm_service_fabric_managed_cluster.res-1
}

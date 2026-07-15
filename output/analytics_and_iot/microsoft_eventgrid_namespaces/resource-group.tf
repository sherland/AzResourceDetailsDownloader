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
  name       = "rg-ardl-13ff285457fead7a"
  tags = {
    armType    = "Microsoft.EventGrid/namespaces"
    createdUtc = "2026-07-15T19:19:09.3506821Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_eventgrid_namespace" "res-1" {
  capacity              = 1
  location              = "westeurope"
  name                  = "egns153-8-ez"
  public_network_access = "Enabled"
  resource_group_name   = azurerm_resource_group.res-0.name
  sku                   = "Standard"
  tags                  = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-13ff285457fead7a"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-13ff285457fead7a/providers/Microsoft.EventGrid/namespaces/egns153-8-ez"
  to = azurerm_eventgrid_namespace.res-1
}

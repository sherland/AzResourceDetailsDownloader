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
  name       = "rg-ardl-9f7012d5f41c8fa4"
  tags = {
    armType    = "Microsoft.DataFactory/factories"
    createdUtc = "2026-08-13T13:23:12.9684314Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_data_factory" "res-1" {
  customer_managed_key_id          = ""
  customer_managed_key_identity_id = ""
  location                         = "norwayeast"
  managed_virtual_network_enabled  = false
  name                             = "adfl4uvvuld"
  public_network_enabled           = true
  purview_id                       = ""
  resource_group_name              = azurerm_resource_group.res-0.name
  tags                             = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9f7012d5f41c8fa4"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9f7012d5f41c8fa4/providers/Microsoft.DataFactory/factories/adfl4uvvuld"
  to = azurerm_data_factory.res-1
}

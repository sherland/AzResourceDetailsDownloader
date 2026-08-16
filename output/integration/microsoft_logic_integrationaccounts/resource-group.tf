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
  name       = "rg-ardl-e58bdfd29b0c6f5a"
  tags = {
    armType    = "Microsoft.Logic/integrationAccounts"
    createdUtc = "2026-08-16T14:22:06.5539222Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_logic_app_integration_account" "res-1" {
  integration_service_environment_id = ""
  location                           = "norwayeast"
  name                               = "iani6kgc-1"
  resource_group_name                = azurerm_resource_group.res-0.name
  sku_name                           = "Free"
  tags                               = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e58bdfd29b0c6f5a"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-e58bdfd29b0c6f5a/providers/Microsoft.Logic/integrationAccounts/iani6kgc-1"
  to = azurerm_logic_app_integration_account.res-1
}

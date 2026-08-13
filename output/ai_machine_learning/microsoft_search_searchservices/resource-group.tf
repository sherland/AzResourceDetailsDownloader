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
  name       = "rg-ardl-8ea2c4413f84d4d7"
  tags = {
    armType    = "Microsoft.Search/searchServices"
    createdUtc = "2026-08-14T10:36:04.7598297Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_search_service" "res-1" {
  allowed_ips                              = []
  authentication_failure_mode              = ""
  customer_managed_key_enforcement_enabled = false
  hosting_mode                             = "Default"
  local_authentication_enabled             = true
  location                                 = "norwayeast"
  name                                     = "srch0v-3un-z"
  network_rule_bypass_option               = "None"
  partition_count                          = 1
  public_network_access_enabled            = true
  replica_count                            = 1
  resource_group_name                      = azurerm_resource_group.res-0.name
  semantic_search_sku                      = ""
  sku                                      = "free"
  tags                                     = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ea2c4413f84d4d7"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ea2c4413f84d4d7/providers/Microsoft.Search/searchServices/srch0v-3un-z"
  to = azurerm_search_service.res-1
}

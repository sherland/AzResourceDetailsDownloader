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
  name       = "rg-ardl-8ea2c4413f84d4d7"
  tags = {
    armType    = "Microsoft.Search/searchServices"
    createdUtc = "2026-07-15T09:27:38.5693447Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_search_service" "res-1" {
  allowed_ips                              = []
  authentication_failure_mode              = ""
  customer_managed_key_enforcement_enabled = false
  hosting_mode                             = "Default"
  local_authentication_enabled             = true
  location                                 = "westeurope"
  name                                     = "srchqyqp-wtf"
  network_rule_bypass_option               = "None"
  partition_count                          = 1
  primary_key                              = "" # Masked sensitive attribute
  public_network_access_enabled            = true
  replica_count                            = 1
  resource_group_name                      = azurerm_resource_group.res-0.name
  secondary_key                            = "" # Masked sensitive attribute
  semantic_search_sku                      = "free"
  sku                                      = "free"
  tags                                     = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ea2c4413f84d4d7"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ea2c4413f84d4d7/providers/Microsoft.Search/searchServices/srchqyqp-wtf"
  to = azurerm_search_service.res-1
}

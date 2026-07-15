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
  name       = "rg-ardl-376bac41699b1ff1"
  tags = {
    armType    = "Microsoft.Network/frontdoorWebApplicationFirewallPolicies"
    createdUtc = "2026-07-15T19:31:06.1217215Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_cdn_frontdoor_firewall_policy" "res-1" {
  custom_block_response_body        = ""
  custom_block_response_status_code = 0
  enabled                           = true
  mode                              = "Prevention"
  name                              = "fdwafkpcnurup"
  redirect_url                      = ""
  request_body_check_enabled        = true
  resource_group_name               = azurerm_resource_group.res-0.name
  sku_name                          = "Standard_AzureFrontDoor"
  tags                              = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-376bac41699b1ff1"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-376bac41699b1ff1/providers/Microsoft.Network/frontDoorWebApplicationFirewallPolicies/fdwafkpcnurup"
  to = azurerm_cdn_frontdoor_firewall_policy.res-1
}

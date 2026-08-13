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
  name       = "rg-ardl-b6cb64ed3b9bae27"
  tags = {
    armType    = "Microsoft.Network/firewallPolicies"
    createdUtc = "2026-08-13T12:51:38.7851047Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_firewall_policy" "res-1" {
  auto_learn_private_ranges_enabled = false
  base_policy_id                    = ""
  location                          = "norwayeast"
  name                              = "afwpgkb-kyp1"
  private_ip_ranges                 = []
  resource_group_name               = azurerm_resource_group.res-0.name
  sku                               = "Standard"
  tags                              = {}
  threat_intelligence_mode          = "Alert"
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b6cb64ed3b9bae27"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b6cb64ed3b9bae27/providers/Microsoft.Network/firewallPolicies/afwpgkb-kyp1"
  to = azurerm_firewall_policy.res-1
}

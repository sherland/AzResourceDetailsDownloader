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
  name       = "rg-ardl-1411ef2d4c4edba8"
  tags = {
    armType    = "Microsoft.Network/firewallPolicies/ruleCollectionGroups"
    createdUtc = "2026-07-15T19:13:08.4845815Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_firewall_policy" "res-1" {
  auto_learn_private_ranges_enabled = false
  base_policy_id                    = ""
  location                          = "westeurope"
  name                              = "afwpd0fjxhjx"
  private_ip_ranges                 = []
  resource_group_name               = azurerm_resource_group.res-0.name
  sku                               = "Standard"
  tags                              = {}
  threat_intelligence_mode          = "Alert"
}
resource "azurerm_firewall_policy_rule_collection_group" "res-2" {
  firewall_policy_id = azurerm_firewall_policy.res-1.id
  name               = "rulecollz2xglx"
  priority           = 100
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1411ef2d4c4edba8"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1411ef2d4c4edba8/providers/Microsoft.Network/firewallPolicies/afwpd0fjxhjx"
  to = azurerm_firewall_policy.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1411ef2d4c4edba8/providers/Microsoft.Network/firewallPolicies/afwpd0fjxhjx/ruleCollectionGroups/rulecollz2xglx"
  to = azurerm_firewall_policy_rule_collection_group.res-2
}

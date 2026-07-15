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
  name       = "rg-ardl-2bfb77d8be121449"
  tags = {
    armType    = "Microsoft.Network/networkSecurityGroups/securityRules"
    createdUtc = "2026-07-15T19:12:10.4338305Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_network_security_group" "res-1" {
  location            = "westeurope"
  name                = "nsgzd-p-0so"
  resource_group_name = azurerm_resource_group.res-0.name
  security_rule = [{
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "443"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "rulebbsk-0"
    priority                                   = 100
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
  }]
  tags = {}
}
resource "azurerm_network_security_rule" "res-2" {
  access                                     = "Allow"
  description                                = ""
  destination_address_prefix                 = "*"
  destination_address_prefixes               = []
  destination_application_security_group_ids = []
  destination_port_range                     = "443"
  destination_port_ranges                    = []
  direction                                  = "Inbound"
  name                                       = "rulebbsk-0"
  network_security_group_name                = "nsgzd-p-0so"
  priority                                   = 100
  protocol                                   = "Tcp"
  resource_group_name                        = azurerm_resource_group.res-0.name
  source_address_prefix                      = "*"
  source_address_prefixes                    = []
  source_application_security_group_ids      = []
  source_port_range                          = "*"
  source_port_ranges                         = []
  depends_on = [
    azurerm_network_security_group.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2bfb77d8be121449"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2bfb77d8be121449/providers/Microsoft.Network/networkSecurityGroups/nsgzd-p-0so"
  to = azurerm_network_security_group.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-2bfb77d8be121449/providers/Microsoft.Network/networkSecurityGroups/nsgzd-p-0so/securityRules/rulebbsk-0"
  to = azurerm_network_security_rule.res-2
}

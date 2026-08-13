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
  name       = "rg-ardl-6220405c5e8fea29"
  tags = {
    armType    = "Microsoft.Network/networkSecurityGroups"
    createdUtc = "2026-08-13T12:30:00.8522264Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_network_security_group" "res-1" {
  location            = "norwayeast"
  name                = "nsgrk86fdry"
  resource_group_name = azurerm_resource_group.res-0.name
  security_rule       = []
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6220405c5e8fea29"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6220405c5e8fea29/providers/Microsoft.Network/networkSecurityGroups/nsgrk86fdry"
  to = azurerm_network_security_group.res-1
}

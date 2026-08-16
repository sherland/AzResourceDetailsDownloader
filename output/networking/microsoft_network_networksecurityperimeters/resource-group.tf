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
  name       = "rg-ardl-0657a2f739507890"
  tags = {
    armType    = "Microsoft.Network/networkSecurityPerimeters"
    createdUtc = "2026-08-16T14:44:56.3995165Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_network_security_perimeter" "res-1" {
  location            = "norwayeast"
  name                = "nspoe-0-nxe"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-0657a2f739507890"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-0657a2f739507890/providers/Microsoft.Network/networkSecurityPerimeters/nspoe-0-nxe"
  to = azurerm_network_security_perimeter.res-1
}

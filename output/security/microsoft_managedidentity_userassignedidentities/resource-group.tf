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
  name       = "rg-ardl-dbfce973e1674818"
  tags = {
    armType    = "Microsoft.ManagedIdentity/userAssignedIdentities"
    createdUtc = "2026-08-14T10:30:32.3134010Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_user_assigned_identity" "res-1" {
  isolation_scope     = ""
  location            = "norwayeast"
  name                = "idntomdsx0"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dbfce973e1674818"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dbfce973e1674818/providers/Microsoft.ManagedIdentity/userAssignedIdentities/idntomdsx0"
  to = azurerm_user_assigned_identity.res-1
}

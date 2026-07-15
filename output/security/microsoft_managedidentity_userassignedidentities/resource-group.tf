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
  name       = "rg-ardl-dbfce973e1674818"
  tags = {
    armType    = "Microsoft.ManagedIdentity/userAssignedIdentities"
    createdUtc = "2026-07-15T09:02:56.0582312Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_user_assigned_identity" "res-1" {
  isolation_scope     = ""
  location            = "westeurope"
  name                = "id9smfdnx8"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dbfce973e1674818"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dbfce973e1674818/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id9smfdnx8"
  to = azurerm_user_assigned_identity.res-1
}

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
  name       = "rg-ardl-08aa11195db40102"
  tags = {
    armType    = "Microsoft.KeyVault/vaults"
    createdUtc = "2026-07-15T09:02:04.4239331Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_key_vault" "res-1" {
  access_policy                   = []
  enable_rbac_authorization       = true
  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false
  location                        = "westeurope"
  name                            = "kv8-9k4hh9"
  public_network_access_enabled   = true
  purge_protection_enabled        = true
  rbac_authorization_enabled      = true
  resource_group_name             = azurerm_resource_group.res-0.name
  sku_name                        = "standard"
  soft_delete_retention_days      = 90
  tags                            = {}
  tenant_id                       = "11111111-1111-1111-1111-111111111111"
  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-08aa11195db40102"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-08aa11195db40102/providers/Microsoft.KeyVault/vaults/kv8-9k4hh9"
  to = azurerm_key_vault.res-1
}

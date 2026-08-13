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
  name       = "rg-ardl-fba1943833ef0847"
  tags = {
    armType    = "Microsoft.Databricks/workspaces"
    createdUtc = "2026-08-13T13:35:56.6684556Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_databricks_workspace" "res-1" {
  customer_managed_key_enabled                        = false
  infrastructure_encryption_enabled                   = false
  load_balancer_backend_address_pool_id               = ""
  location                                            = "norwayeast"
  managed_disk_cmk_key_vault_id                       = ""
  managed_disk_cmk_key_vault_key_id                   = ""
  managed_disk_cmk_rotation_to_latest_version_enabled = false
  managed_resource_group_name                         = "ardl-dbx-managed-xm1ddvc7"
  managed_services_cmk_key_vault_id                   = ""
  managed_services_cmk_key_vault_key_id               = ""
  name                                                = "dbx21a20-w4"
  resource_group_name                                 = azurerm_resource_group.res-0.name
  sku                                                 = "premium"
  tags                                                = {}
  custom_parameters {
    machine_learning_workspace_id                        = ""
    nat_gateway_name                                     = ""
    no_public_ip                                         = true
    private_subnet_name                                  = ""
    private_subnet_network_security_group_association_id = ""
    public_ip_name                                       = ""
    public_subnet_name                                   = ""
    public_subnet_network_security_group_association_id  = ""
    storage_account_name                                 = "dbstoragevpqsauyrlthy4"
    storage_account_sku_name                             = "Standard_ZRS"
    virtual_network_id                                   = ""
    vnet_address_prefix                                  = ""
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fba1943833ef0847"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fba1943833ef0847/providers/Microsoft.Databricks/workspaces/dbx21a20-w4"
  to = azurerm_databricks_workspace.res-1
}

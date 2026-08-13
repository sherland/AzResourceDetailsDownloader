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
  name       = "rg-ardl-3d02f34382fe8092"
  tags = {
    armType    = "Microsoft.Storage/storageAccounts/fileServices/shares"
    createdUtc = "2026-08-13T14:03:39.1726938Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_storage_account" "res-1" {
  access_tier                       = "Hot"
  account_kind                      = "StorageV2"
  account_replication_type          = "LRS"
  account_tier                      = "Standard"
  allow_nested_items_to_be_public   = false
  allowed_copy_scope                = ""
  cross_tenant_replication_enabled  = false
  default_to_oauth_authentication   = false
  dns_endpoint_type                 = "Standard"
  edge_zone                         = ""
  https_traffic_only_enabled        = true
  infrastructure_encryption_enabled = false
  is_hns_enabled                    = false
  large_file_share_enabled          = false
  local_user_enabled                = true
  location                          = "norwayeast"
  min_tls_version                   = "TLS1_2"
  name                              = "stpl8vn5g1"
  nfsv3_enabled                     = false
  provisioned_billing_model_version = ""
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  resource_group_name               = azurerm_resource_group.res-0.name
  sftp_enabled                      = false
  shared_access_key_enabled         = true
  table_encryption_key_type         = "Service"
  tags                              = {}
  blob_properties {
    change_feed_enabled           = false
    change_feed_retention_in_days = 0
    default_service_version       = ""
    last_access_time_enabled      = false
    versioning_enabled            = false
  }
  network_rules {
    bypass                     = ["None"]
    default_action             = "Allow"
    ip_rules                   = []
    virtual_network_subnet_ids = []
  }
  share_properties {
    retention_policy {
      days = 7
    }
  }
}
resource "azurerm_storage_share" "res-4" {
  access_tier          = "TransactionOptimized"
  enabled_protocol     = "SMB"
  metadata             = {}
  name                 = "sharep39ot7"
  quota                = 5
  storage_account_id   = azurerm_storage_account.res-1.id
  storage_account_name = ""
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3d02f34382fe8092"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3d02f34382fe8092/providers/Microsoft.Storage/storageAccounts/stpl8vn5g1"
  to = azurerm_storage_account.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3d02f34382fe8092/providers/Microsoft.Storage/storageAccounts/stpl8vn5g1/fileServices/default/shares/sharep39ot7"
  to = azurerm_storage_share.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3d02f34382fe8092/providers/Microsoft.Storage/storageAccounts/stpl8vn5g1"
  to = azurerm_storage_account_queue_properties.res-5
}

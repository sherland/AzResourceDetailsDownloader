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
  name       = "rg-ardl-04193cb7b9ed5985"
  tags = {
    armType    = "Microsoft.Insights/metricAlerts"
    createdUtc = "2026-07-15T11:13:13.8713357Z"
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
  location                          = "westeurope"
  min_tls_version                   = "TLS1_2"
  name                              = "stagf5ppwn"
  nfsv3_enabled                     = false
  primary_access_key                = "" # Masked sensitive attribute
  primary_blob_connection_string    = "" # Masked sensitive attribute
  primary_connection_string         = "" # Masked sensitive attribute
  provisioned_billing_model_version = ""
  public_network_access_enabled     = true
  queue_encryption_key_type         = "Service"
  resource_group_name               = azurerm_resource_group.res-0.name
  secondary_access_key              = "" # Masked sensitive attribute
  secondary_blob_connection_string  = "" # Masked sensitive attribute
  secondary_connection_string       = "" # Masked sensitive attribute
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


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-04193cb7b9ed5985"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-04193cb7b9ed5985/providers/Microsoft.Storage/storageAccounts/stagf5ppwn"
  to = azurerm_storage_account.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-04193cb7b9ed5985/providers/Microsoft.Storage/storageAccounts/stagf5ppwn"
  to = azurerm_storage_account_queue_properties.res-4
}

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
  name       = "rg-ardl-bb17cace9b9db143"
  tags = {
    armType    = "Microsoft.Synapse/workspaces"
    createdUtc = "2026-08-13T14:24:43.7817308Z"
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
  is_hns_enabled                    = true
  large_file_share_enabled          = false
  local_user_enabled                = true
  location                          = "norwayeast"
  min_tls_version                   = "TLS1_2"
  name                              = "stuyb3hfcc"
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
resource "azurerm_storage_container" "res-3" {
  container_access_type             = "private"
  default_encryption_scope          = "$account-encryption-key"
  encryption_scope_override_enabled = true
  metadata                          = {}
  name                              = "synapsefs"
  storage_account_id                = azurerm_storage_account.res-1.id
  storage_account_name              = ""
}
resource "azurerm_synapse_workspace" "res-7" {
  azuread_authentication_only          = false
  location                             = "swedencentral"
  managed_resource_group_name          = "synapseworkspace-managedrg-945c621f-d7b5-4575-8e8f-fbb85f62b017"
  managed_virtual_network_enabled      = false
  name                                 = "synjhp9-iao"
  public_network_access_enabled        = true
  resource_group_name                  = azurerm_resource_group.res-0.name
  sql_administrator_login              = "azrddadmin"
  sql_administrator_login_password     = "" # Masked sensitive attribute
  sql_identity_control_enabled         = false
  storage_data_lake_gen2_filesystem_id = "https://stuyb3hfcc.dfs.core.windows.net/synapsefs"
  tags                                 = {}
  identity {
    identity_ids = []
    type         = "SystemAssigned"
  }
}
resource "azurerm_synapse_workspace_extended_auditing_policy" "res-11" {
  log_monitoring_enabled                  = false
  retention_in_days                       = 0
  storage_account_access_key              = "" # Masked sensitive attribute
  storage_account_access_key_is_secondary = false
  storage_endpoint                        = ""
  synapse_workspace_id                    = azurerm_synapse_workspace.res-7.id
}
resource "azurerm_synapse_integration_runtime_azure" "res-12" {
  description          = ""
  location             = "AutoResolve"
  name                 = "AutoResolveIntegrationRuntime"
  synapse_workspace_id = azurerm_synapse_workspace.res-7.id
}
resource "azurerm_synapse_workspace_security_alert_policy" "res-13" {
  disabled_alerts              = []
  email_account_admins_enabled = false
  email_addresses              = []
  policy_state                 = "Disabled"
  retention_days               = 0
  storage_account_access_key   = "" # Masked sensitive attribute
  storage_endpoint             = ""
  synapse_workspace_id         = azurerm_synapse_workspace.res-7.id
}
resource "azurerm_synapse_workspace_vulnerability_assessment" "res-14" {
  storage_account_access_key         = "" # Masked sensitive attribute
  storage_container_path             = ""
  storage_container_sas_key          = "" # Masked sensitive attribute
  workspace_security_alert_policy_id = azurerm_synapse_workspace_security_alert_policy.res-13.id
  recurring_scans {
    email_subscription_admins_enabled = true
    emails                            = []
    enabled                           = false
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Storage/storageAccounts/stuyb3hfcc"
  to = azurerm_storage_account.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Storage/storageAccounts/stuyb3hfcc/blobServices/default/containers/synapsefs"
  to = azurerm_storage_container.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Storage/storageAccounts/stuyb3hfcc"
  to = azurerm_storage_account_queue_properties.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Synapse/workspaces/synjhp9-iao"
  to = azurerm_synapse_workspace.res-7
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Synapse/workspaces/synjhp9-iao/extendedAuditingSettings/Default"
  to = azurerm_synapse_workspace_extended_auditing_policy.res-11
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Synapse/workspaces/synjhp9-iao/integrationRuntimes/AutoResolveIntegrationRuntime"
  to = azurerm_synapse_integration_runtime_azure.res-12
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Synapse/workspaces/synjhp9-iao/securityAlertPolicies/Default"
  to = azurerm_synapse_workspace_security_alert_policy.res-13
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bb17cace9b9db143/providers/Microsoft.Synapse/workspaces/synjhp9-iao/vulnerabilityAssessments/Default"
  to = azurerm_synapse_workspace_vulnerability_assessment.res-14
}

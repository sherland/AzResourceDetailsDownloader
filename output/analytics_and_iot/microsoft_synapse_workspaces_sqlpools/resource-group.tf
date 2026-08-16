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
  name       = "rg-ardl-3c9ca4169b7ea45b"
  tags = {
    armType    = "Microsoft.Synapse/workspaces/sqlPools"
    createdUtc = "2026-08-16T14:54:36.0110080Z"
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
  name                              = "stjdj4ltxv"
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
  managed_resource_group_name          = "synapseworkspace-managedrg-5100b7fe-1476-4087-9aca-39c95c115b49"
  managed_virtual_network_enabled      = false
  name                                 = "synd92txe0r"
  public_network_access_enabled        = true
  resource_group_name                  = azurerm_resource_group.res-0.name
  sql_administrator_login              = "azrddadmin"
  sql_administrator_login_password     = "" # Masked sensitive attribute
  sql_identity_control_enabled         = false
  storage_data_lake_gen2_filesystem_id = "https://stjdj4ltxv.dfs.core.windows.net/synapsefs"
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
resource "azurerm_synapse_sql_pool" "res-14" {
  collation                 = "SQL_Latin1_General_CP1_CI_AS"
  create_mode               = "Default"
  data_encrypted            = false
  geo_backup_policy_enabled = true
  name                      = "sqlpool1"
  sku_name                  = "DW100c"
  storage_account_type      = "GRS"
  synapse_workspace_id      = azurerm_synapse_workspace.res-7.id
  tags                      = {}
}
resource "azurerm_synapse_sql_pool_extended_auditing_policy" "res-16" {
  log_monitoring_enabled                  = false
  retention_in_days                       = 0
  sql_pool_id                             = azurerm_synapse_sql_pool.res-14.id
  storage_account_access_key              = "" # Masked sensitive attribute
  storage_account_access_key_is_secondary = false
  storage_endpoint                        = ""
}
resource "azurerm_synapse_sql_pool_security_alert_policy" "res-18" {
  disabled_alerts              = []
  email_account_admins_enabled = false
  email_addresses              = []
  policy_state                 = "Disabled"
  retention_days               = 0
  sql_pool_id                  = azurerm_synapse_sql_pool.res-14.id
  storage_account_access_key   = "" # Masked sensitive attribute
  storage_endpoint             = ""
}
resource "azurerm_synapse_sql_pool_vulnerability_assessment" "res-20" {
  sql_pool_security_alert_policy_id = azurerm_synapse_sql_pool_security_alert_policy.res-18.id
  storage_account_access_key        = "" # Masked sensitive attribute
  storage_container_path            = ""
  storage_container_sas_key         = "" # Masked sensitive attribute
  recurring_scans {
    email_subscription_admins_enabled = true
    emails                            = []
    enabled                           = false
  }
}
resource "azurerm_synapse_sql_pool_workload_group" "res-21" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 22
  min_resource_percent               = 0
  min_resource_percent_per_request   = 22
  name                               = "largerc"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-22" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "largerc"
  name              = "largerc"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-21.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-23" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 10
  min_resource_percent               = 0
  min_resource_percent_per_request   = 10
  name                               = "mediumrc"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-24" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "mediumrc"
  name              = "mediumrc"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-23.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-25" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 3
  min_resource_percent               = 0
  min_resource_percent_per_request   = 3
  name                               = "smallrc"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-26" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "smallrc"
  name              = "smallrc"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-25.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-27" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 0.4
  min_resource_percent               = 0
  min_resource_percent_per_request   = 0.4
  name                               = "staticrc10"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-28" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc10"
  name              = "staticrc10"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-27.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-29" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 0.8
  min_resource_percent               = 0
  min_resource_percent_per_request   = 0.8
  name                               = "staticrc20"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-30" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc20"
  name              = "staticrc20"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-29.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-31" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 1.6
  min_resource_percent               = 0
  min_resource_percent_per_request   = 1.6
  name                               = "staticrc30"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-32" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc30"
  name              = "staticrc30"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-31.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-33" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 3.2
  min_resource_percent               = 0
  min_resource_percent_per_request   = 3.2
  name                               = "staticrc40"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-34" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc40"
  name              = "staticrc40"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-33.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-35" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 6.4
  min_resource_percent               = 0
  min_resource_percent_per_request   = 6.4
  name                               = "staticrc50"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-36" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc50"
  name              = "staticrc50"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-35.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-37" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 12.8
  min_resource_percent               = 0
  min_resource_percent_per_request   = 12.8
  name                               = "staticrc60"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-38" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc60"
  name              = "staticrc60"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-37.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-39" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 25.6
  min_resource_percent               = 0
  min_resource_percent_per_request   = 25.6
  name                               = "staticrc70"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-40" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc70"
  name              = "staticrc70"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-39.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-41" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 51.2
  min_resource_percent               = 0
  min_resource_percent_per_request   = 51.2
  name                               = "staticrc80"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-42" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "staticrc80"
  name              = "staticrc80"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-41.id
}
resource "azurerm_synapse_sql_pool_workload_group" "res-43" {
  importance                         = "normal"
  max_resource_percent               = 100
  max_resource_percent_per_request   = 70
  min_resource_percent               = 0
  min_resource_percent_per_request   = 70
  name                               = "xlargerc"
  query_execution_timeout_in_seconds = 0
  sql_pool_id                        = azurerm_synapse_sql_pool.res-14.id
}
resource "azurerm_synapse_sql_pool_workload_classifier" "res-44" {
  context           = ""
  end_time          = ""
  importance        = "normal"
  label             = ""
  member_name       = "xlargerc"
  name              = "xlargerc"
  start_time        = ""
  workload_group_id = azurerm_synapse_sql_pool_workload_group.res-43.id
}
resource "azurerm_synapse_workspace_vulnerability_assessment" "res-45" {
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Storage/storageAccounts/stjdj4ltxv"
  to = azurerm_storage_account.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Storage/storageAccounts/stjdj4ltxv/blobServices/default/containers/synapsefs"
  to = azurerm_storage_container.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Storage/storageAccounts/stjdj4ltxv"
  to = azurerm_storage_account_queue_properties.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r"
  to = azurerm_synapse_workspace.res-7
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/extendedAuditingSettings/Default"
  to = azurerm_synapse_workspace_extended_auditing_policy.res-11
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/integrationRuntimes/AutoResolveIntegrationRuntime"
  to = azurerm_synapse_integration_runtime_azure.res-12
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/securityAlertPolicies/Default"
  to = azurerm_synapse_workspace_security_alert_policy.res-13
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1"
  to = azurerm_synapse_sql_pool.res-14
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/extendedAuditingSettings/Default"
  to = azurerm_synapse_sql_pool_extended_auditing_policy.res-16
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/securityAlertPolicies/Default"
  to = azurerm_synapse_sql_pool_security_alert_policy.res-18
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/vulnerabilityAssessments/Default"
  to = azurerm_synapse_sql_pool_vulnerability_assessment.res-20
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/largerc"
  to = azurerm_synapse_sql_pool_workload_group.res-21
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/largerc/workloadClassifiers/largerc"
  to = azurerm_synapse_sql_pool_workload_classifier.res-22
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/mediumrc"
  to = azurerm_synapse_sql_pool_workload_group.res-23
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/mediumrc/workloadClassifiers/mediumrc"
  to = azurerm_synapse_sql_pool_workload_classifier.res-24
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/smallrc"
  to = azurerm_synapse_sql_pool_workload_group.res-25
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/smallrc/workloadClassifiers/smallrc"
  to = azurerm_synapse_sql_pool_workload_classifier.res-26
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc10"
  to = azurerm_synapse_sql_pool_workload_group.res-27
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc10/workloadClassifiers/staticrc10"
  to = azurerm_synapse_sql_pool_workload_classifier.res-28
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc20"
  to = azurerm_synapse_sql_pool_workload_group.res-29
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc20/workloadClassifiers/staticrc20"
  to = azurerm_synapse_sql_pool_workload_classifier.res-30
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc30"
  to = azurerm_synapse_sql_pool_workload_group.res-31
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc30/workloadClassifiers/staticrc30"
  to = azurerm_synapse_sql_pool_workload_classifier.res-32
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc40"
  to = azurerm_synapse_sql_pool_workload_group.res-33
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc40/workloadClassifiers/staticrc40"
  to = azurerm_synapse_sql_pool_workload_classifier.res-34
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc50"
  to = azurerm_synapse_sql_pool_workload_group.res-35
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc50/workloadClassifiers/staticrc50"
  to = azurerm_synapse_sql_pool_workload_classifier.res-36
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc60"
  to = azurerm_synapse_sql_pool_workload_group.res-37
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc60/workloadClassifiers/staticrc60"
  to = azurerm_synapse_sql_pool_workload_classifier.res-38
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc70"
  to = azurerm_synapse_sql_pool_workload_group.res-39
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc70/workloadClassifiers/staticrc70"
  to = azurerm_synapse_sql_pool_workload_classifier.res-40
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc80"
  to = azurerm_synapse_sql_pool_workload_group.res-41
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/staticrc80/workloadClassifiers/staticrc80"
  to = azurerm_synapse_sql_pool_workload_classifier.res-42
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/xlargerc"
  to = azurerm_synapse_sql_pool_workload_group.res-43
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/sqlPools/sqlpool1/workloadGroups/xlargerc/workloadClassifiers/xlargerc"
  to = azurerm_synapse_sql_pool_workload_classifier.res-44
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-3c9ca4169b7ea45b/providers/Microsoft.Synapse/workspaces/synd92txe0r/vulnerabilityAssessments/Default"
  to = azurerm_synapse_workspace_vulnerability_assessment.res-45
}

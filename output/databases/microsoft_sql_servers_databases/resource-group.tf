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
  name       = "rg-ardl-b7061c5cd70d41ff"
  tags = {
    armType    = "Microsoft.Sql/servers/databases"
    createdUtc = "2026-08-14T10:29:40.2653662Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_mssql_server" "res-1" {
  administrator_login                          = "azrddadmin"
  administrator_login_password                 = "" # Masked sensitive attribute
  administrator_login_password_wo              = "" # Masked sensitive attribute
  administrator_login_password_wo_version      = 0
  connection_policy                            = "Default"
  express_vulnerability_assessment_enabled     = false
  location                                     = "swedencentral"
  minimum_tls_version                          = "1.2"
  name                                         = "sql1ifqz7nd"
  outbound_network_restriction_enabled         = false
  primary_user_assigned_identity_id            = ""
  public_network_access_enabled                = true
  resource_group_name                          = azurerm_resource_group.res-0.name
  tags                                         = {}
  transparent_data_encryption_key_vault_key_id = ""
  version                                      = "12.0"
}
resource "azurerm_mssql_database" "res-11" {
  auto_pause_delay_in_minutes                                = 0
  collation                                                  = "SQL_Latin1_General_CP1_CI_AS"
  create_mode                                                = "Default"
  elastic_pool_id                                            = ""
  enclave_type                                               = ""
  geo_backup_enabled                                         = true
  ledger_enabled                                             = false
  license_type                                               = ""
  maintenance_configuration_name                             = "SQL_Default"
  max_size_gb                                                = 2
  min_capacity                                               = 0
  name                                                       = "dbikse00"
  read_replica_count                                         = 0
  read_scale                                                 = false
  secondary_type                                             = ""
  server_id                                                  = azurerm_mssql_server.res-1.id
  sku_name                                                   = "Basic"
  storage_account_type                                       = "Geo"
  tags                                                       = {}
  transparent_data_encryption_enabled                        = true
  transparent_data_encryption_key_automatic_rotation_enabled = false
  transparent_data_encryption_key_vault_key_id               = ""
  zone_redundant                                             = false
  long_term_retention_policy {
    immutable_backups_enabled = false
    monthly_retention         = "PT0S"
    week_of_year              = 1
    weekly_retention          = "PT0S"
    yearly_retention          = "PT0S"
  }
  short_term_retention_policy {
    backup_interval_in_hours = 24
    retention_days           = 7
  }
  threat_detection_policy {
    disabled_alerts            = []
    email_account_admins       = "Disabled"
    email_addresses            = []
    retention_days             = 0
    state                      = "Disabled"
    storage_account_access_key = "" # Masked sensitive attribute
    storage_endpoint           = ""
  }
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-22" {
  database_id                             = azurerm_mssql_database.res-11.id
  enabled                                 = false
  log_monitoring_enabled                  = false
  retention_in_days                       = 0
  storage_account_access_key              = "" # Masked sensitive attribute
  storage_account_access_key_is_secondary = false
  storage_endpoint                        = ""
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-31" {
  database_id                             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/databases/master"
  enabled                                 = false
  log_monitoring_enabled                  = false
  retention_in_days                       = 0
  storage_account_access_key              = "" # Masked sensitive attribute
  storage_account_access_key_is_secondary = false
  storage_endpoint                        = ""
}
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "res-37" {
  blob_storage_endpoint           = ""
  enabled                         = false
  log_monitoring_enabled          = false
  server_id                       = azurerm_mssql_server.res-1.id
  storage_account_access_key      = "" # Masked sensitive attribute
  storage_account_subscription_id = "" # Masked sensitive attribute
}
resource "azurerm_mssql_server_transparent_data_encryption" "res-38" {
  auto_rotation_enabled = false
  key_vault_key_id      = ""
  managed_hsm_key_id    = ""
  server_id             = azurerm_mssql_server.res-1.id
}
resource "azurerm_mssql_server_extended_auditing_policy" "res-39" {
  audit_actions_and_groups                = []
  enabled                                 = false
  log_monitoring_enabled                  = false
  predicate_expression                    = ""
  retention_in_days                       = 0
  server_id                               = azurerm_mssql_server.res-1.id
  storage_account_access_key              = "" # Masked sensitive attribute
  storage_account_access_key_is_secondary = false
  storage_account_subscription_id         = "" # Masked sensitive attribute
  storage_endpoint                        = ""
}
resource "azurerm_mssql_server_security_alert_policy" "res-41" {
  disabled_alerts            = []
  email_account_admins       = false
  email_addresses            = []
  resource_group_name        = azurerm_resource_group.res-0.name
  retention_days             = 0
  server_name                = "sql1ifqz7nd"
  state                      = "Disabled"
  storage_account_access_key = "" # Masked sensitive attribute
  storage_endpoint           = ""
  depends_on = [
    azurerm_mssql_server.res-1,
  ]
}
resource "azurerm_mssql_server_vulnerability_assessment" "res-43" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.res-41.id
  storage_account_access_key      = "" # Masked sensitive attribute
  storage_container_path          = ""
  storage_container_sas_key       = "" # Masked sensitive attribute
  recurring_scans {
    email_subscription_admins = true
    emails                    = []
    enabled                   = false
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd"
  to = azurerm_mssql_server.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/databases/dbikse00"
  to = azurerm_mssql_database.res-11
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/databases/dbikse00/extendedAuditingSettings/Default"
  to = azurerm_mssql_database_extended_auditing_policy.res-22
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/databases/master/extendedAuditingSettings/Default"
  to = azurerm_mssql_database_extended_auditing_policy.res-31
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/devOpsAuditingSettings/Default"
  to = azurerm_mssql_server_microsoft_support_auditing_policy.res-37
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/encryptionProtector/current"
  to = azurerm_mssql_server_transparent_data_encryption.res-38
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/extendedAuditingSettings/Default"
  to = azurerm_mssql_server_extended_auditing_policy.res-39
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/securityAlertPolicies/Default"
  to = azurerm_mssql_server_security_alert_policy.res-41
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b7061c5cd70d41ff/providers/Microsoft.Sql/servers/sql1ifqz7nd/vulnerabilityAssessments/Default"
  to = azurerm_mssql_server_vulnerability_assessment.res-43
}

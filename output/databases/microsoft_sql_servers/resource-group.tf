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
  location   = "westeurope"
  managed_by = ""
  name       = "rg-ardl-d2d1e6175e7bd2ef"
  tags = {
    armType    = "Microsoft.Sql/servers"
    createdUtc = "2026-07-15T08:58:36.0847152Z"
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
  location                                     = "westeurope"
  minimum_tls_version                          = "1.2"
  name                                         = "sqlfmf2kgqp"
  outbound_network_restriction_enabled         = false
  primary_user_assigned_identity_id            = ""
  public_network_access_enabled                = true
  resource_group_name                          = azurerm_resource_group.res-0.name
  tags                                         = {}
  transparent_data_encryption_key_vault_key_id = ""
  version                                      = "12.0"
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-14" {
  database_id                             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp/databases/master"
  enabled                                 = false
  log_monitoring_enabled                  = false
  retention_in_days                       = 0
  storage_account_access_key              = "" # Masked sensitive attribute
  storage_account_access_key_is_secondary = false
  storage_endpoint                        = ""
}
resource "azurerm_mssql_server_microsoft_support_auditing_policy" "res-20" {
  blob_storage_endpoint           = ""
  enabled                         = false
  log_monitoring_enabled          = false
  server_id                       = azurerm_mssql_server.res-1.id
  storage_account_access_key      = "" # Masked sensitive attribute
  storage_account_subscription_id = "" # Masked sensitive attribute
}
resource "azurerm_mssql_server_transparent_data_encryption" "res-21" {
  auto_rotation_enabled = false
  key_vault_key_id      = ""
  managed_hsm_key_id    = ""
  server_id             = azurerm_mssql_server.res-1.id
}
resource "azurerm_mssql_server_extended_auditing_policy" "res-22" {
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
resource "azurerm_mssql_server_security_alert_policy" "res-24" {
  disabled_alerts            = []
  email_account_admins       = false
  email_addresses            = []
  resource_group_name        = azurerm_resource_group.res-0.name
  retention_days             = 0
  server_name                = "sqlfmf2kgqp"
  state                      = "Disabled"
  storage_account_access_key = "" # Masked sensitive attribute
  storage_endpoint           = ""
  depends_on = [
    azurerm_mssql_server.res-1,
  ]
}
resource "azurerm_mssql_server_vulnerability_assessment" "res-26" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.res-24.id
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp"
  to = azurerm_mssql_server.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp/databases/master/extendedAuditingSettings/Default"
  to = azurerm_mssql_database_extended_auditing_policy.res-14
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp/devOpsAuditingSettings/Default"
  to = azurerm_mssql_server_microsoft_support_auditing_policy.res-20
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp/encryptionProtector/current"
  to = azurerm_mssql_server_transparent_data_encryption.res-21
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp/extendedAuditingSettings/Default"
  to = azurerm_mssql_server_extended_auditing_policy.res-22
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp/securityAlertPolicies/Default"
  to = azurerm_mssql_server_security_alert_policy.res-24
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d2d1e6175e7bd2ef/providers/Microsoft.Sql/servers/sqlfmf2kgqp/vulnerabilityAssessments/Default"
  to = azurerm_mssql_server_vulnerability_assessment.res-26
}

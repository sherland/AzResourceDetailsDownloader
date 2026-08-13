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
  name       = "rg-ardl-b5f32dd1b32c637f"
  tags = {
    armType    = "Microsoft.Sql/servers/elasticPools"
    createdUtc = "2026-08-13T14:14:31.3356097Z"
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
  name                                         = "sqlgtm7-5ek"
  outbound_network_restriction_enabled         = false
  primary_user_assigned_identity_id            = ""
  public_network_access_enabled                = true
  resource_group_name                          = azurerm_resource_group.res-0.name
  tags                                         = {}
  transparent_data_encryption_key_vault_key_id = ""
  version                                      = "12.0"
}
resource "azurerm_mssql_database_extended_auditing_policy" "res-14" {
  database_id                             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/databases/master"
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
resource "azurerm_mssql_elasticpool" "res-21" {
  enclave_type                    = ""
  high_availability_replica_count = 0
  license_type                    = "LicenseIncluded"
  location                        = "swedencentral"
  maintenance_configuration_name  = "SQL_Default"
  max_size_bytes                  = 5242880000
  max_size_gb                     = 4.8828125
  name                            = "poolcmer4b"
  resource_group_name             = azurerm_resource_group.res-0.name
  server_name                     = "sqlgtm7-5ek"
  tags                            = {}
  zone_redundant                  = false
  per_database_settings {
    max_capacity = 5
    min_capacity = 0
  }
  sku {
    capacity = 50
    family   = ""
    name     = "BasicPool"
    tier     = "Basic"
  }
  depends_on = [
    azurerm_mssql_server.res-1,
  ]
}
resource "azurerm_mssql_server_transparent_data_encryption" "res-22" {
  auto_rotation_enabled = false
  key_vault_key_id      = ""
  managed_hsm_key_id    = ""
  server_id             = azurerm_mssql_server.res-1.id
}
resource "azurerm_mssql_server_extended_auditing_policy" "res-23" {
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
resource "azurerm_mssql_server_security_alert_policy" "res-25" {
  disabled_alerts            = []
  email_account_admins       = false
  email_addresses            = []
  resource_group_name        = azurerm_resource_group.res-0.name
  retention_days             = 0
  server_name                = "sqlgtm7-5ek"
  state                      = "Disabled"
  storage_account_access_key = "" # Masked sensitive attribute
  storage_endpoint           = ""
  depends_on = [
    azurerm_mssql_server.res-1,
  ]
}
resource "azurerm_mssql_server_vulnerability_assessment" "res-27" {
  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.res-25.id
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek"
  to = azurerm_mssql_server.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/databases/master/extendedAuditingSettings/Default"
  to = azurerm_mssql_database_extended_auditing_policy.res-14
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/devOpsAuditingSettings/Default"
  to = azurerm_mssql_server_microsoft_support_auditing_policy.res-20
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/elasticPools/poolcmer4b"
  to = azurerm_mssql_elasticpool.res-21
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/encryptionProtector/current"
  to = azurerm_mssql_server_transparent_data_encryption.res-22
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/extendedAuditingSettings/Default"
  to = azurerm_mssql_server_extended_auditing_policy.res-23
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/securityAlertPolicies/Default"
  to = azurerm_mssql_server_security_alert_policy.res-25
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b5f32dd1b32c637f/providers/Microsoft.Sql/servers/sqlgtm7-5ek/vulnerabilityAssessments/Default"
  to = azurerm_mssql_server_vulnerability_assessment.res-27
}

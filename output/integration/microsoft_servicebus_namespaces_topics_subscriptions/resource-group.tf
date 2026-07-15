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
  name       = "rg-ardl-9e05ace8d6857eb2"
  tags = {
    armType    = "Microsoft.ServiceBus/namespaces/topics/subscriptions"
    createdUtc = "2026-07-15T19:11:39.5847130Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_servicebus_namespace" "res-1" {
  capacity                      = 0
  local_auth_enabled            = true
  location                      = "westeurope"
  minimum_tls_version           = "1.2"
  name                          = "sbg0yna0pz"
  premium_messaging_partitions  = 0
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  sku                           = "Standard"
  tags                          = {}
  network_rule_set {
    default_action                = "Allow"
    ip_rules                      = []
    public_network_access_enabled = true
    trusted_services_allowed      = false
  }
}
resource "azurerm_servicebus_namespace_authorization_rule" "res-2" {
  listen       = true
  manage       = true
  name         = "RootManageSharedAccessKey"
  namespace_id = azurerm_servicebus_namespace.res-1.id
  send         = true
}
resource "azurerm_servicebus_topic" "res-4" {
  auto_delete_on_idle                     = "P10675199DT2H48M5.4775807S"
  batched_operations_enabled              = true
  default_message_ttl                     = "P10675199DT2H48M5.4775807S"
  duplicate_detection_history_time_window = "PT10M"
  express_enabled                         = false
  max_message_size_in_kilobytes           = 256
  max_size_in_megabytes                   = 1024
  name                                    = "topicvj-o3e"
  namespace_id                            = azurerm_servicebus_namespace.res-1.id
  partitioning_enabled                    = false
  requires_duplicate_detection            = false
  status                                  = "Active"
  support_ordering                        = true
}
resource "azurerm_servicebus_subscription" "res-5" {
  auto_delete_on_idle                       = "P10675199DT2H48M5.4775807S"
  batched_operations_enabled                = true
  client_scoped_subscription_enabled        = false
  dead_lettering_on_filter_evaluation_error = true
  dead_lettering_on_message_expiration      = false
  default_message_ttl                       = "P10675199DT2H48M5.4775807S"
  forward_dead_lettered_messages_to         = ""
  forward_to                                = ""
  lock_duration                             = "PT1M"
  max_delivery_count                        = 10
  name                                      = "subuea0ba"
  requires_session                          = false
  status                                    = "Active"
  topic_id                                  = azurerm_servicebus_topic.res-4.id
}
resource "azurerm_servicebus_subscription_rule" "res-6" {
  action          = ""
  filter_type     = "SqlFilter"
  name            = "$Default"
  sql_filter      = "1=1"
  subscription_id = azurerm_servicebus_subscription.res-5.id
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9e05ace8d6857eb2"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9e05ace8d6857eb2/providers/Microsoft.ServiceBus/namespaces/sbg0yna0pz"
  to = azurerm_servicebus_namespace.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9e05ace8d6857eb2/providers/Microsoft.ServiceBus/namespaces/sbg0yna0pz/authorizationRules/RootManageSharedAccessKey"
  to = azurerm_servicebus_namespace_authorization_rule.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9e05ace8d6857eb2/providers/Microsoft.ServiceBus/namespaces/sbg0yna0pz/topics/topicvj-o3e"
  to = azurerm_servicebus_topic.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9e05ace8d6857eb2/providers/Microsoft.ServiceBus/namespaces/sbg0yna0pz/topics/topicvj-o3e/subscriptions/subuea0ba"
  to = azurerm_servicebus_subscription.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9e05ace8d6857eb2/providers/Microsoft.ServiceBus/namespaces/sbg0yna0pz/topics/topicvj-o3e/subscriptions/subuea0ba/rules/$Default"
  to = azurerm_servicebus_subscription_rule.res-6
}

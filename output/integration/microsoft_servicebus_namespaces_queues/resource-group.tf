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
  name       = "rg-ardl-d9387f30331fd3f1"
  tags = {
    armType    = "Microsoft.ServiceBus/namespaces/queues"
    createdUtc = "2026-08-16T13:26:15.4976810Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_servicebus_namespace" "res-1" {
  capacity                      = 0
  local_auth_enabled            = true
  location                      = "norwayeast"
  minimum_tls_version           = "1.2"
  name                          = "sbookpd3-f"
  premium_messaging_partitions  = 0
  public_network_access_enabled = true
  resource_group_name           = azurerm_resource_group.res-0.name
  sku                           = "Basic"
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
resource "azurerm_servicebus_queue" "res-4" {
  auto_delete_on_idle                     = "P10675199DT2H48M5.4775807S"
  batched_operations_enabled              = true
  dead_lettering_on_message_expiration    = false
  default_message_ttl                     = "P14D"
  duplicate_detection_history_time_window = "PT10M"
  express_enabled                         = false
  forward_dead_lettered_messages_to       = ""
  forward_to                              = ""
  lock_duration                           = "PT1M"
  max_delivery_count                      = 10
  max_message_size_in_kilobytes           = 256
  max_size_in_megabytes                   = 1024
  name                                    = "queuee2e7-c"
  namespace_id                            = azurerm_servicebus_namespace.res-1.id
  partitioning_enabled                    = false
  requires_duplicate_detection            = false
  requires_session                        = false
  status                                  = "Active"
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d9387f30331fd3f1"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d9387f30331fd3f1/providers/Microsoft.ServiceBus/namespaces/sbookpd3-f"
  to = azurerm_servicebus_namespace.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d9387f30331fd3f1/providers/Microsoft.ServiceBus/namespaces/sbookpd3-f/authorizationRules/RootManageSharedAccessKey"
  to = azurerm_servicebus_namespace_authorization_rule.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-d9387f30331fd3f1/providers/Microsoft.ServiceBus/namespaces/sbookpd3-f/queues/queuee2e7-c"
  to = azurerm_servicebus_queue.res-4
}

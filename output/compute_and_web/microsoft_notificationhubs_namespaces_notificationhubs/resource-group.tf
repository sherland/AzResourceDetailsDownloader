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
  name       = "rg-ardl-b8c084b4de7ff61e"
  tags = {
    armType    = "Microsoft.NotificationHubs/namespaces/notificationHubs"
    createdUtc = "2026-07-15T09:28:33.7097899Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_notification_hub_namespace" "res-1" {
  enabled                 = true
  location                = "westeurope"
  name                    = "nhnsmuv5af-w"
  replication_region      = "default"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku_name                = "Free"
  tags                    = {}
  zone_redundancy_enabled = false
}
resource "azurerm_notification_hub" "res-3" {
  location            = "westeurope"
  name                = "hub7jf4-l"
  namespace_name      = "nhnsmuv5af-w"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  depends_on = [
    azurerm_notification_hub_namespace.res-1,
  ]
}
resource "azurerm_notification_hub_authorization_rule" "res-4" {
  listen                      = true
  manage                      = true
  name                        = "DefaultFullSharedAccessSignature"
  namespace_name              = "nhnsmuv5af-w"
  notification_hub_name       = "hub7jf4-l"
  primary_access_key          = "" # Masked sensitive attribute
  primary_connection_string   = "" # Masked sensitive attribute
  resource_group_name         = azurerm_resource_group.res-0.name
  secondary_access_key        = "" # Masked sensitive attribute
  secondary_connection_string = "" # Masked sensitive attribute
  send                        = true
  depends_on = [
    azurerm_notification_hub.res-3,
  ]
}
resource "azurerm_notification_hub_authorization_rule" "res-5" {
  listen                      = true
  manage                      = false
  name                        = "DefaultListenSharedAccessSignature"
  namespace_name              = "nhnsmuv5af-w"
  notification_hub_name       = "hub7jf4-l"
  primary_access_key          = "" # Masked sensitive attribute
  primary_connection_string   = "" # Masked sensitive attribute
  resource_group_name         = azurerm_resource_group.res-0.name
  secondary_access_key        = "" # Masked sensitive attribute
  secondary_connection_string = "" # Masked sensitive attribute
  send                        = false
  depends_on = [
    azurerm_notification_hub.res-3,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b8c084b4de7ff61e"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b8c084b4de7ff61e/providers/Microsoft.NotificationHubs/namespaces/nhnsmuv5af-w"
  to = azurerm_notification_hub_namespace.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b8c084b4de7ff61e/providers/Microsoft.NotificationHubs/namespaces/nhnsmuv5af-w/notificationHubs/hub7jf4-l"
  to = azurerm_notification_hub.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b8c084b4de7ff61e/providers/Microsoft.NotificationHubs/namespaces/nhnsmuv5af-w/notificationHubs/hub7jf4-l/authorizationRules/DefaultFullSharedAccessSignature"
  to = azurerm_notification_hub_authorization_rule.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-b8c084b4de7ff61e/providers/Microsoft.NotificationHubs/namespaces/nhnsmuv5af-w/notificationHubs/hub7jf4-l/authorizationRules/DefaultListenSharedAccessSignature"
  to = azurerm_notification_hub_authorization_rule.res-5
}

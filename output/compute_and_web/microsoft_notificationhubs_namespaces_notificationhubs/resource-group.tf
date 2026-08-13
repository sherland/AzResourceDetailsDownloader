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
  name       = "rg-ardl-b8c084b4de7ff61e"
  tags = {
    armType    = "Microsoft.NotificationHubs/namespaces/notificationHubs"
    createdUtc = "2026-08-13T12:59:34.1307043Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_notification_hub_namespace" "res-1" {
  enabled                 = true
  location                = "norwayeast"
  name                    = "nhnsmuv5af-w"
  replication_region      = "default"
  resource_group_name     = azurerm_resource_group.res-0.name
  sku_name                = "Free"
  tags                    = {}
  zone_redundancy_enabled = true
}
resource "azurerm_notification_hub" "res-3" {
  location            = "norwayeast"
  name                = "hub7jf4-l"
  namespace_name      = "nhnsmuv5af-w"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  depends_on = [
    azurerm_notification_hub_namespace.res-1,
  ]
}
resource "azurerm_notification_hub_authorization_rule" "res-4" {
  listen                = true
  manage                = true
  name                  = "DefaultFullSharedAccessSignature"
  namespace_name        = "nhnsmuv5af-w"
  notification_hub_name = "hub7jf4-l"
  resource_group_name   = azurerm_resource_group.res-0.name
  send                  = true
  depends_on = [
    azurerm_notification_hub.res-3,
  ]
}
resource "azurerm_notification_hub_authorization_rule" "res-5" {
  listen                = true
  manage                = false
  name                  = "DefaultListenSharedAccessSignature"
  namespace_name        = "nhnsmuv5af-w"
  notification_hub_name = "hub7jf4-l"
  resource_group_name   = azurerm_resource_group.res-0.name
  send                  = false
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

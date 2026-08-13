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
  name       = "rg-ardl-95916d9ffe1c6d7d"
  tags = {
    armType    = "Microsoft.Network/trafficManagerProfiles"
    createdUtc = "2026-08-13T14:37:37.0755107Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_traffic_manager_profile" "res-1" {
  max_return             = 0
  name                   = "tmtb-tu10b"
  profile_status         = "Enabled"
  resource_group_name    = azurerm_resource_group.res-0.name
  tags                   = {}
  traffic_routing_method = "Performance"
  traffic_view_enabled   = false
  dns_config {
    relative_name = "ardltmt9deegag"
    ttl           = 30
  }
  monitor_config {
    expected_status_code_ranges  = []
    interval_in_seconds          = 30
    path                         = "/"
    port                         = 443
    protocol                     = "HTTPS"
    timeout_in_seconds           = 10
    tolerated_number_of_failures = 3
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-95916d9ffe1c6d7d"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-95916d9ffe1c6d7d/providers/Microsoft.Network/trafficManagerProfiles/tmtb-tu10b"
  to = azurerm_traffic_manager_profile.res-1
}

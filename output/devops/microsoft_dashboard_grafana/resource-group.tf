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
  name       = "rg-ardl-9c207da75b61d6f9"
  tags = {
    armType    = "Microsoft.Dashboard/grafana"
    createdUtc = "2026-08-14T10:35:34.4788171Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_dashboard_grafana" "res-1" {
  api_key_enabled                        = false
  auto_generated_domain_name_label_scope = "TenantReuse"
  deterministic_outbound_ip_enabled      = false
  grafana_major_version                  = "12"
  location                               = "norwayeast"
  name                                   = "grfobls6-wo"
  public_network_access_enabled          = true
  resource_group_name                    = azurerm_resource_group.res-0.name
  sku                                    = "Standard"
  sku_size                               = "X1"
  tags                                   = {}
  zone_redundancy_enabled                = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9c207da75b61d6f9"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-9c207da75b61d6f9/providers/Microsoft.Dashboard/grafana/grfobls6-wo"
  to = azurerm_dashboard_grafana.res-1
}

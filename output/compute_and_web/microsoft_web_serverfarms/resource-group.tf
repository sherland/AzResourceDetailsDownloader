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
  name       = "rg-ardl-6c73a914c7d661b1"
  tags = {
    armType    = "Microsoft.Web/serverfarms"
    createdUtc = "2026-07-15T09:08:09.9036283Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_service_plan" "res-1" {
  app_service_environment_id      = ""
  location                        = "westeurope"
  maximum_elastic_worker_count    = 1
  name                            = "planvwrvnc-q"
  os_type                         = "Linux"
  per_site_scaling_enabled        = false
  premium_plan_auto_scale_enabled = false
  resource_group_name             = azurerm_resource_group.res-0.name
  sku_name                        = "B1"
  tags                            = {}
  worker_count                    = 1
  zone_balancing_enabled          = false
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6c73a914c7d661b1"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6c73a914c7d661b1/providers/Microsoft.Web/serverFarms/planvwrvnc-q"
  to = azurerm_service_plan.res-1
}

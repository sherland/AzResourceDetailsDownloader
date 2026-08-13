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
  name       = "rg-ardl-6c73a914c7d661b1"
  tags = {
    armType    = "Microsoft.Web/serverfarms"
    createdUtc = "2026-08-13T14:53:21.1286260Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_service_plan" "res-1" {
  app_service_environment_id      = ""
  location                        = "swedencentral"
  maximum_elastic_worker_count    = 1
  name                            = "planm4ir-vcl"
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-6c73a914c7d661b1/providers/Microsoft.Web/serverFarms/planm4ir-vcl"
  to = azurerm_service_plan.res-1
}

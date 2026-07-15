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
  name       = "rg-ardl-872102314c593a7d"
  tags = {
    armType    = "Microsoft.Logic/workflows"
    createdUtc = "2026-07-15T09:37:00.1658410Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_logic_app_workflow" "res-1" {
  enabled                            = true
  integration_service_environment_id = ""
  location                           = "westeurope"
  logic_app_integration_account_id   = ""
  name                               = "logicylsb-d-i"
  resource_group_name                = azurerm_resource_group.res-0.name
  tags                               = {}
  workflow_schema                    = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"
  workflow_version                   = "1.0.0.0"
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-872102314c593a7d"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-872102314c593a7d/providers/Microsoft.Logic/workflows/logicylsb-d-i"
  to = azurerm_logic_app_workflow.res-1
}

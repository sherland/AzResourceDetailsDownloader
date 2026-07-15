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
  name       = "rg-ardl-bdf6a4dadf2c40ee"
  tags = {
    armType    = "Microsoft.ContainerInstance/containerGroups"
    createdUtc = "2026-07-15T09:09:36.7357490Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_container_group" "res-1" {
  dns_name_label_reuse_policy = "Unsecure"
  location                    = "westeurope"
  name                        = "acitk-i-5-3"
  os_type                     = "Linux"
  priority                    = ""
  resource_group_name         = azurerm_resource_group.res-0.name
  restart_policy              = "Never"
  sku                         = "Standard"
  subnet_ids                  = []
  tags                        = {}
  zones                       = []
  container {
    commands                     = []
    cpu                          = 1
    cpu_limit                    = 0
    environment_variables        = {}
    image                        = "mcr.microsoft.com/azuredocs/aci-helloworld"
    memory                       = 1
    memory_limit                 = 0
    name                         = "main"
    secure_environment_variables = {} # Masked sensitive attribute
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bdf6a4dadf2c40ee"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-bdf6a4dadf2c40ee/providers/Microsoft.ContainerInstance/containerGroups/acitk-i-5-3"
  to = azurerm_container_group.res-1
}

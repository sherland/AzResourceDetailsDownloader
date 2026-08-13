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
  name       = "rg-ardl-dd78496389a3f338"
  tags = {
    armType    = "Microsoft.Maintenance/maintenanceConfigurations"
    createdUtc = "2026-08-13T12:53:36.5575681Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_maintenance_configuration" "res-1" {
  in_guest_user_patch_mode = "User"
  location                 = "norwayeast"
  name                     = "mclpeogsoh"
  properties               = {}
  resource_group_name      = azurerm_resource_group.res-0.name
  scope                    = "InGuestPatch"
  tags                     = {}
  visibility               = "Custom"
  install_patches {
    reboot = "IfRequired"
    linux {
      classifications_to_include    = ["Critical", "Security"]
      package_names_mask_to_exclude = []
      package_names_mask_to_include = []
    }
    windows {
      classifications_to_include = ["Critical", "Security"]
      kb_numbers_to_exclude      = []
      kb_numbers_to_include      = []
    }
  }
  window {
    duration             = "03:00"
    expiration_date_time = ""
    recur_every          = "1Day"
    start_date_time      = "2030-01-01 00:00"
    time_zone            = "UTC"
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dd78496389a3f338"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-dd78496389a3f338/providers/Microsoft.Maintenance/maintenanceConfigurations/mclpeogsoh"
  to = azurerm_maintenance_configuration.res-1
}

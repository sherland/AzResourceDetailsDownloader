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
  name       = "rg-ardl-eecb9a7ad07dc5a9"
  tags = {
    armType    = "Microsoft.Compute/galleries/images"
    createdUtc = "2026-08-14T10:34:43.0429792Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_shared_image_gallery" "res-1" {
  description         = ""
  location            = "norwayeast"
  name                = "gals0yvwobz"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
}
resource "azurerm_shared_image" "res-2" {
  accelerated_network_support_enabled = false
  architecture                        = "x64"
  confidential_vm_enabled             = false
  confidential_vm_supported           = false
  description                         = ""
  disk_controller_type_nvme_enabled   = false
  disk_types_not_allowed              = []
  eula                                = ""
  gallery_name                        = "gals0yvwobz"
  hibernation_enabled                 = false
  hyper_v_generation                  = "V1"
  location                            = "norwayeast"
  max_recommended_memory_in_gb        = 0
  max_recommended_vcpu_count          = 0
  min_recommended_memory_in_gb        = 0
  min_recommended_vcpu_count          = 0
  name                                = "imgyoclcp"
  os_type                             = "Linux"
  privacy_statement_uri               = ""
  release_note_uri                    = ""
  resource_group_name                 = azurerm_resource_group.res-0.name
  specialized                         = false
  tags                                = {}
  trusted_launch_enabled              = false
  trusted_launch_supported            = false
  identifier {
    offer     = "ardl-offer"
    publisher = "ardl"
    sku       = "ardl-sku"
  }
  depends_on = [
    azurerm_shared_image_gallery.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-eecb9a7ad07dc5a9"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-eecb9a7ad07dc5a9/providers/Microsoft.Compute/galleries/gals0yvwobz"
  to = azurerm_shared_image_gallery.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-eecb9a7ad07dc5a9/providers/Microsoft.Compute/galleries/gals0yvwobz/images/imgyoclcp"
  to = azurerm_shared_image.res-2
}

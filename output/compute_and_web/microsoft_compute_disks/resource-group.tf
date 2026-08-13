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
  name       = "rg-ardl-ab7325b8645ba734"
  tags = {
    armType    = "Microsoft.Compute/disks"
    createdUtc = "2026-08-14T10:28:00.7544354Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_managed_disk" "res-1" {
  create_option                     = "Empty"
  disk_access_id                    = ""
  disk_encryption_set_id            = ""
  disk_iops_read_only               = 0
  disk_iops_read_write              = 500
  disk_mbps_read_only               = 0
  disk_mbps_read_write              = 60
  disk_size_gb                      = 4
  edge_zone                         = ""
  gallery_image_reference_id        = ""
  hyper_v_generation                = ""
  image_reference_id                = ""
  location                          = "norwayeast"
  max_shares                        = 0
  name                              = "disk4-94-a-6"
  network_access_policy             = "AllowAll"
  on_demand_bursting_enabled        = false
  optimized_frequent_attach_enabled = false
  os_type                           = ""
  performance_plus_enabled          = false
  public_network_access_enabled     = true
  resource_group_name               = azurerm_resource_group.res-0.name
  secure_vm_disk_encryption_set_id  = ""
  security_type                     = ""
  source_resource_id                = ""
  source_uri                        = ""
  storage_account_id                = ""
  storage_account_type              = "Standard_LRS"
  tags                              = {}
  tier                              = ""
  trusted_launch_enabled            = false
  upload_size_bytes                 = 0
  zone                              = ""
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ab7325b8645ba734"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-ab7325b8645ba734/providers/Microsoft.Compute/disks/disk4-94-a-6"
  to = azurerm_managed_disk.res-1
}

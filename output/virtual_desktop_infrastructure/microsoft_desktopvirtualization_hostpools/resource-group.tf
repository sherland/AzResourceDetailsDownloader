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
  name       = "rg-ardl-c6c6c5710a932f1f"
  tags = {
    armType    = "Microsoft.DesktopVirtualization/hostPools"
    createdUtc = "2026-08-13T14:13:55.1163026Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_desktop_host_pool" "res-1" {
  custom_rdp_properties            = "drivestoredirect:s:;usbdevicestoredirect:s:;redirectclipboard:i:0;redirectprinters:i:0;audiomode:i:0;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;"
  description                      = ""
  friendly_name                    = ""
  load_balancer_type               = "BreadthFirst"
  location                         = "northeurope"
  maximum_sessions_allowed         = 999999
  name                             = "avdhpnqrqlt-t"
  personal_desktop_assignment_type = ""
  preferred_app_group_type         = "Desktop"
  public_network_access            = "Enabled"
  resource_group_name              = azurerm_resource_group.res-0.name
  start_vm_on_connect              = false
  tags                             = {}
  type                             = "Pooled"
  validate_environment             = false
  vm_template                      = ""
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c6c6c5710a932f1f"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-c6c6c5710a932f1f/providers/Microsoft.DesktopVirtualization/hostPools/avdhpnqrqlt-t"
  to = azurerm_virtual_desktop_host_pool.res-1
}

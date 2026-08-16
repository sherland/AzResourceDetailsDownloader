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
  name       = "rg-ardl-0b1b89abf1e402c6"
  tags = {
    armType    = "Microsoft.DesktopVirtualization/applicationGroups"
    createdUtc = "2026-08-16T13:45:28.8327980Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_virtual_desktop_application_group" "res-1" {
  default_desktop_display_name = "SessionDesktop"
  description                  = ""
  friendly_name                = ""
  host_pool_id                 = azurerm_virtual_desktop_host_pool.res-2.id
  location                     = "northeurope"
  name                         = "avdagc-7s-3r1"
  resource_group_name          = azurerm_resource_group.res-0.name
  tags                         = {}
  type                         = "Desktop"
}
resource "azurerm_virtual_desktop_host_pool" "res-2" {
  custom_rdp_properties            = "drivestoredirect:s:;usbdevicestoredirect:s:;redirectclipboard:i:0;redirectprinters:i:0;audiomode:i:0;videoplaybackmode:i:1;devicestoredirect:s:*;redirectcomports:i:1;redirectsmartcards:i:1;enablecredsspsupport:i:1;redirectwebauthn:i:1;use multimon:i:1;"
  description                      = ""
  friendly_name                    = ""
  load_balancer_type               = "BreadthFirst"
  location                         = "northeurope"
  maximum_sessions_allowed         = 999999
  name                             = "avdhpz-3v-b-9"
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
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-0b1b89abf1e402c6"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-0b1b89abf1e402c6/providers/Microsoft.DesktopVirtualization/applicationGroups/avdagc-7s-3r1"
  to = azurerm_virtual_desktop_application_group.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-0b1b89abf1e402c6/providers/Microsoft.DesktopVirtualization/hostPools/avdhpz-3v-b-9"
  to = azurerm_virtual_desktop_host_pool.res-2
}

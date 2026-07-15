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
  name       = "rg-ardl-fc5ae4a395470e0a"
  tags = {
    armType    = "Microsoft.Network/dnsZones"
    createdUtc = "2026-07-15T18:55:39.0401734Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_dns_zone" "res-1" {
  name                = "ardllnkmwt9n.contoso.com"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  soa_record {
    email         = "azuredns-hostmaster.microsoft.com"
    expire_time   = 2419200
    minimum_ttl   = 300
    refresh_time  = 3600
    retry_time    = 300
    serial_number = 1
    tags          = {}
    ttl           = 3600
  }
}
resource "azurerm_dns_ns_record" "res-2" {
  name                = "@"
  records             = ["ns1-08.azure-dns.com.", "ns2-08.azure-dns.net.", "ns3-08.azure-dns.org.", "ns4-08.azure-dns.info."]
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  ttl                 = 172800
  zone_name           = "ardllnkmwt9n.contoso.com"
  depends_on = [
    azurerm_dns_zone.res-1,
  ]
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fc5ae4a395470e0a"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fc5ae4a395470e0a/providers/Microsoft.Network/dnsZones/ardllnkmwt9n.contoso.com"
  to = azurerm_dns_zone.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-fc5ae4a395470e0a/providers/Microsoft.Network/dnsZones/ardllnkmwt9n.contoso.com/NS/@"
  to = azurerm_dns_ns_record.res-2
}

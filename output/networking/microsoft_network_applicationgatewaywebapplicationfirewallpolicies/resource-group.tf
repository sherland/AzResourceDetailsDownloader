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
  name       = "rg-ardl-582b196a4c103d52"
  tags = {
    armType    = "Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies"
    createdUtc = "2026-08-16T13:35:52.8904817Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_web_application_firewall_policy" "res-1" {
  location            = "norwayeast"
  name                = "wafiorgu-xh"
  resource_group_name = azurerm_resource_group.res-0.name
  tags                = {}
  managed_rules {
    managed_rule_set {
      type    = "OWASP"
      version = "3.2"
    }
  }
  policy_settings {
    enabled                                   = true
    file_upload_enforcement                   = true
    file_upload_limit_in_mb                   = 100
    js_challenge_cookie_expiration_in_minutes = 30
    max_request_body_size_in_kb               = 128
    mode                                      = "Prevention"
    request_body_check                        = true
    request_body_enforcement                  = true
    request_body_inspect_limit_in_kb          = 128
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-582b196a4c103d52"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-582b196a4c103d52/providers/Microsoft.Network/applicationGatewayWebApplicationFirewallPolicies/wafiorgu-xh"
  to = azurerm_web_application_firewall_policy.res-1
}

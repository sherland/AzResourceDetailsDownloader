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
  name       = "rg-ardl-8ca095e8942b47ed"
  tags = {
    armType    = "Microsoft.Insights/webtests"
    createdUtc = "2026-08-13T13:06:41.0878008Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_application_insights" "res-1" {
  application_type                      = "web"
  daily_data_cap_in_gb                  = 100
  daily_data_cap_notifications_disabled = false
  daily_data_cap_notifications_enabled  = true
  disable_ip_masking                    = false
  force_customer_storage_for_profiler   = false
  internet_ingestion_enabled            = true
  internet_query_enabled                = true
  ip_masking_enabled                    = true
  local_authentication_disabled         = false
  local_authentication_enabled          = true
  location                              = "norwayeast"
  name                                  = "aic-x782c5"
  resource_group_name                   = azurerm_resource_group.res-0.name
  retention_in_days                     = 90
  sampling_percentage                   = 0
  tags                                  = {}
  workspace_id                          = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/ai_aic-x782c5_2b291e4c-a1e7-477c-99ec-35a5f9966760_managed/providers/Microsoft.OperationalInsights/workspaces/managed-aic-x782c5-ws"
}
resource "azurerm_application_insights_web_test" "res-2" {
  application_insights_id = azurerm_application_insights.res-1.id
  configuration           = "<WebTest Name='ARDL' Enabled='True' Timeout='30' xmlns='http://microsoft.com/schemas/VisualStudio/TeamTest/2010'><Items><Request Method='GET' Url='https://www.microsoft.com' ThinkTime='0' Timeout='30' ParseDependentRequests='False' FollowRedirects='True' RecordResult='True' Cache='False' ResponseTimeGoal='0' Encoding='utf-8' ExpectedHttpStatusCode='200' ExpectedResponseUrl='' ReportingName='' IgnoreHttpStatusCode='False' /></Items></WebTest>"
  description             = ""
  enabled                 = true
  frequency               = 300
  geo_locations           = ["us-tx-sn1-azr"]
  kind                    = "ping"
  location                = "norwayeast"
  name                    = "wt9s8-znrt"
  resource_group_name     = azurerm_resource_group.res-0.name
  retry_enabled           = false
  tags = {
    "hidden-link:/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ca095e8942b47ed/providers/Microsoft.Insights/components/aic-x782c5" = "Resource"
  }
  timeout = 30
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ca095e8942b47ed"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ca095e8942b47ed/providers/Microsoft.Insights/components/aic-x782c5"
  to = azurerm_application_insights.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-8ca095e8942b47ed/providers/Microsoft.Insights/webTests/wt9s8-znrt"
  to = azurerm_application_insights_web_test.res-2
}

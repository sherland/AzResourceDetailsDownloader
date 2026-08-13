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
  name       = "rg-ardl-1c6da0a56560fd63"
  tags = {
    armType    = "Microsoft.Insights/dataCollectionRules"
    createdUtc = "2026-08-14T10:37:56.3060187Z"
    purpose    = "az-resource-details-downloader"
  }
}
resource "azurerm_monitor_data_collection_rule" "res-1" {
  data_collection_endpoint_id = ""
  description                 = ""
  kind                        = ""
  location                    = "norwayeast"
  name                        = "dcrnabr7xkd"
  resource_group_name         = azurerm_resource_group.res-0.name
  tags                        = {}
  data_flow {
    built_in_transform = ""
    destinations       = ["destination-log"]
    output_stream      = ""
    streams            = ["Microsoft-Perf"]
    transform_kql      = ""
  }
  data_sources {
    performance_counter {
      counter_specifiers            = ["\\Processor(_Total)\\% Processor Time"]
      name                          = "perfCounter1"
      sampling_frequency_in_seconds = 60
      streams                       = ["Microsoft-Perf"]
    }
  }
  destinations {
    log_analytics {
      name                  = "destination-log"
      workspace_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et"
    }
  }
}
resource "azurerm_log_analytics_workspace" "res-2" {
  allow_resource_only_permissions         = true
  cmk_for_query_forced                    = false
  daily_quota_gb                          = -1
  data_collection_rule_id                 = ""
  immediate_data_purge_on_30_days_enabled = false
  internet_ingestion_enabled              = true
  internet_query_enabled                  = true
  location                                = "norwayeast"
  name                                    = "laws1-sf5et"
  resource_group_name                     = azurerm_resource_group.res-0.name
  retention_in_days                       = 30
  sku                                     = "PerGB2018"
  tags                                    = {}
}
resource "azurerm_log_analytics_saved_search" "res-3" {
  category                   = "General Exploration"
  display_name               = "All Computers with their most recent data"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_General|AlphabeticallySortedComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-4" {
  category                   = "General Exploration"
  display_name               = "Stale Computers (data older than 24 hours)"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_General|StaleComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-5" {
  category                   = "General Exploration"
  display_name               = "Which Management Group is generating the most data points?"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_General|dataPointsPerManagementGroup"
  query                      = "search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-6" {
  category                   = "General Exploration"
  display_name               = "Distribution of data Types"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_General|dataTypeDistribution"
  query                      = "search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-7" {
  category                   = "Log Management"
  display_name               = "All Events"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|AllEvents"
  query                      = "Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-8" {
  category                   = "Log Management"
  display_name               = "All Syslogs"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|AllSyslog"
  query                      = "Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-9" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by Facility"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|AllSyslogByFacility"
  query                      = "Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-10" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by ProcessName"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|AllSyslogByProcessName"
  query                      = "Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-11" {
  category                   = "Log Management"
  display_name               = "All Syslog Records with Errors"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|AllSyslogsWithErrors"
  query                      = "Syslog | where SeverityLevel == \"error\" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-12" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by Client IP Address"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-13" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by HTTP Method"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-14" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Client IP Address"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|CountIISLogEntriesClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-15" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP Request Method"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-16" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP User Agent"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-17" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Host requested by client"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-18" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL for the host \"www.contoso.com\" (replace with your own)"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|CountOfIISLogEntriesByURLForHost"
  query                      = "search csHost == \"www.contoso.com\" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost=\"www.contoso.com\" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-19" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL requested by client (without query strings)"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-20" {
  category                   = "Log Management"
  display_name               = "Count of Events with level \"Warning\" grouped by Event ID"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|CountOfWarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-21" {
  category                   = "Log Management"
  display_name               = "Shows breakdown of response codes"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|DisplayBreakdownRespondCodes"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-22" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Log"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|EventsByEventLog"
  query                      = "Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-23" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Source"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|EventsByEventSource"
  query                      = "Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-24" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event ID"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|EventsByEventsID"
  query                      = "Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-25" {
  category                   = "Log Management"
  display_name               = "Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|EventsInOMBetween2000to3000"
  query                      = "Event | where EventLog == \"Operations Manager\" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Operations Manager\" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-26" {
  category                   = "Log Management"
  display_name               = "Count of Events containing the word \"started\" grouped by EventID"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|EventsWithStartedinEventID"
  query                      = "search in (Event) \"started\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event \"started\" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-27" {
  category                   = "Log Management"
  display_name               = "Find the maximum time taken for each page"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|FindMaximumTimeTakenForEachPage"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-28" {
  category                   = "Log Management"
  display_name               = "IIS Log Entries for a specific client IP Address (replace with your own)"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|IISLogEntriesForClientIP"
  query                      = "search cIP == \"192.168.0.1\" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP=\"192.168.0.1\" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-29" {
  category                   = "Log Management"
  display_name               = "All IIS Log Entries"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|ListAllIISLogEntries"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-30" {
  category                   = "Log Management"
  display_name               = "How many connections to Operations Manager's SDK service by day"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|NoOfConnectionsToOMSDKService"
  query                      = "Event | where EventID == 26328 and EventLog == \"Operations Manager\" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog=\"Operations Manager\" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-31" {
  category                   = "Log Management"
  display_name               = "When did my servers initiate restart?"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|ServerRestartTime"
  query                      = "search in (Event) \"shutdown\" and EventLog == \"System\" and Source == \"User32\" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-32" {
  category                   = "Log Management"
  display_name               = "Shows which pages people are getting a 404 for"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|Show404PagesList"
  query                      = "search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-33" {
  category                   = "Log Management"
  display_name               = "Shows servers that are throwing internal server error"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|ShowServersThrowingInternalServerError"
  query                      = "search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-34" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each Azure Role Instance"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-35" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each IIS Computer"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|TotalBytesReceivedByEachIISComputer"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-36" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by Client IP Address"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-37" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by each IIS ServerIP Address"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-38" {
  category                   = "Log Management"
  display_name               = "Total Bytes sent by Client IP Address"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|TotalBytesSentByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-39" {
  category                   = "Log Management"
  display_name               = "All Events with level \"Warning\""
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|WarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-40" {
  category                   = "Log Management"
  display_name               = "Windows Firewall Policy settings have changed"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|WindowsFireawallPolicySettingsChanged"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_saved_search" "res-41" {
  category                   = "Log Management"
  display_name               = "On which machines and how many times have Windows Firewall Policy settings changed"
  function_alias             = ""
  function_parameters        = []
  log_analytics_workspace_id = azurerm_log_analytics_workspace.res-2.id
  name                       = "LogManagement(laws1-sf5et)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  tags                       = {}
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-42" {
  description             = ""
  display_name            = "AACAudit"
  name                    = "AACAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-43" {
  description             = ""
  display_name            = "AACHttpRequest"
  name                    = "AACHttpRequest"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-44" {
  description             = ""
  display_name            = "AADAgentRiskEvents"
  name                    = "AADAgentRiskEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-45" {
  description             = ""
  display_name            = "AADB2CRequestLogs"
  name                    = "AADB2CRequestLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-46" {
  description             = ""
  display_name            = "AADCustomSecurityAttributeAuditLogs"
  name                    = "AADCustomSecurityAttributeAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-47" {
  description             = ""
  display_name            = "AADDomainServicesAccountLogon"
  name                    = "AADDomainServicesAccountLogon"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-48" {
  description             = ""
  display_name            = "AADDomainServicesAccountManagement"
  name                    = "AADDomainServicesAccountManagement"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-49" {
  description             = ""
  display_name            = "AADDomainServicesDNSAuditsDynamicUpdates"
  name                    = "AADDomainServicesDNSAuditsDynamicUpdates"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-50" {
  description             = ""
  display_name            = "AADDomainServicesDNSAuditsGeneral"
  name                    = "AADDomainServicesDNSAuditsGeneral"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-51" {
  description             = ""
  display_name            = "AADDomainServicesDirectoryServiceAccess"
  name                    = "AADDomainServicesDirectoryServiceAccess"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-52" {
  description             = ""
  display_name            = "AADDomainServicesLogonLogoff"
  name                    = "AADDomainServicesLogonLogoff"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-53" {
  description             = ""
  display_name            = "AADDomainServicesPolicyChange"
  name                    = "AADDomainServicesPolicyChange"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-54" {
  description             = ""
  display_name            = "AADDomainServicesPrivilegeUse"
  name                    = "AADDomainServicesPrivilegeUse"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-55" {
  description             = ""
  display_name            = "AADDomainServicesSystemSecurity"
  name                    = "AADDomainServicesSystemSecurity"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-56" {
  description             = ""
  display_name            = "AADFirstPartyToFirstPartySignInLogs"
  name                    = "AADFirstPartyToFirstPartySignInLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-57" {
  description             = ""
  display_name            = "AADGraphActivityLogs"
  name                    = "AADGraphActivityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-58" {
  description             = ""
  display_name            = "AADManagedIdentitySignInLogs"
  name                    = "AADManagedIdentitySignInLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-59" {
  description             = ""
  display_name            = "AADNonInteractiveUserSignInLogs"
  name                    = "AADNonInteractiveUserSignInLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-60" {
  description             = ""
  display_name            = "AADProvisioningLogs"
  name                    = "AADProvisioningLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-61" {
  description             = ""
  display_name            = "AADRiskyAgents"
  name                    = "AADRiskyAgents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-62" {
  description             = ""
  display_name            = "AADRiskyServicePrincipals"
  name                    = "AADRiskyServicePrincipals"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-63" {
  description             = ""
  display_name            = "AADRiskyUsers"
  name                    = "AADRiskyUsers"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-64" {
  description             = ""
  display_name            = "AADServicePrincipalRiskEvents"
  name                    = "AADServicePrincipalRiskEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-65" {
  description             = ""
  display_name            = "AADServicePrincipalSignInLogs"
  name                    = "AADServicePrincipalSignInLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-66" {
  description             = ""
  display_name            = "AADUserRiskEvents"
  name                    = "AADUserRiskEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-67" {
  description             = ""
  display_name            = "ABSBotRequests"
  name                    = "ABSBotRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-68" {
  description             = ""
  display_name            = "ACICollaborationAudit"
  name                    = "ACICollaborationAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-69" {
  description             = ""
  display_name            = "ACLTransactionLogs"
  name                    = "ACLTransactionLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-70" {
  description             = ""
  display_name            = "ACLUserDefinedLogs"
  name                    = "ACLUserDefinedLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-71" {
  description             = ""
  display_name            = "ACRConnectedClientList"
  name                    = "ACRConnectedClientList"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-72" {
  description             = ""
  display_name            = "ACREntraAuthenticationAuditLog"
  name                    = "ACREntraAuthenticationAuditLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-73" {
  description             = ""
  display_name            = "ACSAdvancedMessagingOperations"
  name                    = "ACSAdvancedMessagingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-74" {
  description             = ""
  display_name            = "ACSAuthIncomingOperations"
  name                    = "ACSAuthIncomingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-75" {
  description             = ""
  display_name            = "ACSBillingUsage"
  name                    = "ACSBillingUsage"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-76" {
  description             = ""
  display_name            = "ACSCallAutomationIncomingOperations"
  name                    = "ACSCallAutomationIncomingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-77" {
  description             = ""
  display_name            = "ACSCallAutomationMediaSummary"
  name                    = "ACSCallAutomationMediaSummary"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-78" {
  description             = ""
  display_name            = "ACSCallAutomationStreamingUsage"
  name                    = "ACSCallAutomationStreamingUsage"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-79" {
  description             = ""
  display_name            = "ACSCallClientMediaStatsTimeSeries"
  name                    = "ACSCallClientMediaStatsTimeSeries"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-80" {
  description             = ""
  display_name            = "ACSCallClientOperations"
  name                    = "ACSCallClientOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-81" {
  description             = ""
  display_name            = "ACSCallClientServiceRequestAndOutcome"
  name                    = "ACSCallClientServiceRequestAndOutcome"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-82" {
  description             = ""
  display_name            = "ACSCallClosedCaptionsSummary"
  name                    = "ACSCallClosedCaptionsSummary"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-83" {
  description             = ""
  display_name            = "ACSCallDiagnostics"
  name                    = "ACSCallDiagnostics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-84" {
  description             = ""
  display_name            = "ACSCallDiagnosticsUpdates"
  name                    = "ACSCallDiagnosticsUpdates"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-85" {
  description             = ""
  display_name            = "ACSCallRecordingIncomingOperations"
  name                    = "ACSCallRecordingIncomingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-86" {
  description             = ""
  display_name            = "ACSCallRecordingSummary"
  name                    = "ACSCallRecordingSummary"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-87" {
  description             = ""
  display_name            = "ACSCallSummary"
  name                    = "ACSCallSummary"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-88" {
  description             = ""
  display_name            = "ACSCallSummaryUpdates"
  name                    = "ACSCallSummaryUpdates"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-89" {
  description             = ""
  display_name            = "ACSCallSurvey"
  name                    = "ACSCallSurvey"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-90" {
  description             = ""
  display_name            = "ACSCallingMetrics"
  name                    = "ACSCallingMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-91" {
  description             = ""
  display_name            = "ACSChatIncomingOperations"
  name                    = "ACSChatIncomingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-92" {
  description             = ""
  display_name            = "ACSEmailSendMailOperational"
  name                    = "ACSEmailSendMailOperational"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-93" {
  description             = ""
  display_name            = "ACSEmailStatusUpdateOperational"
  name                    = "ACSEmailStatusUpdateOperational"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-94" {
  description             = ""
  display_name            = "ACSEmailUserEngagementOperational"
  name                    = "ACSEmailUserEngagementOperational"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-95" {
  description             = ""
  display_name            = "ACSJobRouterIncomingOperations"
  name                    = "ACSJobRouterIncomingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-96" {
  description             = ""
  display_name            = "ACSOptOutManagementOperations"
  name                    = "ACSOptOutManagementOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-97" {
  description             = ""
  display_name            = "ACSRoomsIncomingOperations"
  name                    = "ACSRoomsIncomingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-98" {
  description             = ""
  display_name            = "ACSSMSIncomingOperations"
  name                    = "ACSSMSIncomingOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-99" {
  description             = ""
  display_name            = "ADAssessmentRecommendation"
  name                    = "ADAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-100" {
  description             = ""
  display_name            = "ADFActivityRun"
  name                    = "ADFActivityRun"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-101" {
  description             = ""
  display_name            = "ADFAirflowSchedulerLogs"
  name                    = "ADFAirflowSchedulerLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-102" {
  description             = ""
  display_name            = "ADFAirflowTaskLogs"
  name                    = "ADFAirflowTaskLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-103" {
  description             = ""
  display_name            = "ADFAirflowWebLogs"
  name                    = "ADFAirflowWebLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-104" {
  description             = ""
  display_name            = "ADFAirflowWorkerLogs"
  name                    = "ADFAirflowWorkerLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-105" {
  description             = ""
  display_name            = "ADFPipelineRun"
  name                    = "ADFPipelineRun"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-106" {
  description             = ""
  display_name            = "ADFSSISIntegrationRuntimeLogs"
  name                    = "ADFSSISIntegrationRuntimeLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-107" {
  description             = ""
  display_name            = "ADFSSISPackageEventMessageContext"
  name                    = "ADFSSISPackageEventMessageContext"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-108" {
  description             = ""
  display_name            = "ADFSSISPackageEventMessages"
  name                    = "ADFSSISPackageEventMessages"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-109" {
  description             = ""
  display_name            = "ADFSSISPackageExecutableStatistics"
  name                    = "ADFSSISPackageExecutableStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-110" {
  description             = ""
  display_name            = "ADFSSISPackageExecutionComponentPhases"
  name                    = "ADFSSISPackageExecutionComponentPhases"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-111" {
  description             = ""
  display_name            = "ADFSSISPackageExecutionDataStatistics"
  name                    = "ADFSSISPackageExecutionDataStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-112" {
  description             = ""
  display_name            = "ADFSSignInLogs"
  name                    = "ADFSSignInLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-113" {
  description             = ""
  display_name            = "ADFSandboxActivityRun"
  name                    = "ADFSandboxActivityRun"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-114" {
  description             = ""
  display_name            = "ADFSandboxPipelineRun"
  name                    = "ADFSandboxPipelineRun"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-115" {
  description             = ""
  display_name            = "ADFTriggerRun"
  name                    = "ADFTriggerRun"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-116" {
  description             = ""
  display_name            = "ADGSyslogEvent"
  name                    = "ADGSyslogEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-117" {
  description             = ""
  display_name            = "ADReplicationResult"
  name                    = "ADReplicationResult"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-118" {
  description             = ""
  display_name            = "ADSecurityAssessmentRecommendation"
  name                    = "ADSecurityAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-119" {
  description             = ""
  display_name            = "ADTDataHistoryOperation"
  name                    = "ADTDataHistoryOperation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-120" {
  description             = ""
  display_name            = "ADTDigitalTwinsOperation"
  name                    = "ADTDigitalTwinsOperation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-121" {
  description             = ""
  display_name            = "ADTEventRoutesOperation"
  name                    = "ADTEventRoutesOperation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-122" {
  description             = ""
  display_name            = "ADTModelsOperation"
  name                    = "ADTModelsOperation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-123" {
  description             = ""
  display_name            = "ADTQueryOperation"
  name                    = "ADTQueryOperation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-124" {
  description             = ""
  display_name            = "ADXCommand"
  name                    = "ADXCommand"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-125" {
  description             = ""
  display_name            = "ADXDataOperation"
  name                    = "ADXDataOperation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-126" {
  description             = ""
  display_name            = "ADXIngestionBatching"
  name                    = "ADXIngestionBatching"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-127" {
  description             = ""
  display_name            = "ADXJournal"
  name                    = "ADXJournal"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-128" {
  description             = ""
  display_name            = "ADXQuery"
  name                    = "ADXQuery"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-129" {
  description             = ""
  display_name            = "ADXTableDetails"
  name                    = "ADXTableDetails"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-130" {
  description             = ""
  display_name            = "ADXTableUsageStatistics"
  name                    = "ADXTableUsageStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-131" {
  description             = ""
  display_name            = "AEWAssignmentBlobLogs"
  name                    = "AEWAssignmentBlobLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-132" {
  description             = ""
  display_name            = "AEWAuditLogs"
  name                    = "AEWAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-133" {
  description             = ""
  display_name            = "AEWComputePipelinesLogs"
  name                    = "AEWComputePipelinesLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-134" {
  description             = ""
  display_name            = "AEWExperimentAssignmentSummary"
  name                    = "AEWExperimentAssignmentSummary"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-135" {
  description             = ""
  display_name            = "AEWExperimentScorecardMetricPairs"
  name                    = "AEWExperimentScorecardMetricPairs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-136" {
  description             = ""
  display_name            = "AEWExperimentScorecards"
  name                    = "AEWExperimentScorecards"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-137" {
  description             = ""
  display_name            = "AFSAuditLogs"
  name                    = "AFSAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-138" {
  description             = ""
  display_name            = "AGCAccessLogs"
  name                    = "AGCAccessLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-139" {
  description             = ""
  display_name            = "AGCFirewallLogs"
  name                    = "AGCFirewallLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-140" {
  description             = ""
  display_name            = "AGSGrafanaAlertAuthFailure"
  name                    = "AGSGrafanaAlertAuthFailure"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-141" {
  description             = ""
  display_name            = "AGSGrafanaLoginEvents"
  name                    = "AGSGrafanaLoginEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-142" {
  description             = ""
  display_name            = "AGSGrafanaUsageInsightsEvents"
  name                    = "AGSGrafanaUsageInsightsEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-143" {
  description             = ""
  display_name            = "AGSUpdateEvents"
  name                    = "AGSUpdateEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-144" {
  description             = ""
  display_name            = "AGWAccessLogs"
  name                    = "AGWAccessLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-145" {
  description             = ""
  display_name            = "AGWFirewallLogs"
  name                    = "AGWFirewallLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-146" {
  description             = ""
  display_name            = "AGWPerformanceLogs"
  name                    = "AGWPerformanceLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-147" {
  description             = ""
  display_name            = "AHCIDiagnosticLogs"
  name                    = "AHCIDiagnosticLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-148" {
  description             = ""
  display_name            = "AHDSDeidAuditLogs"
  name                    = "AHDSDeidAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-149" {
  description             = ""
  display_name            = "AHDSDicomAuditLogs"
  name                    = "AHDSDicomAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-150" {
  description             = ""
  display_name            = "AHDSDicomDiagnosticLogs"
  name                    = "AHDSDicomDiagnosticLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-151" {
  description             = ""
  display_name            = "AHDSMedTechDiagnosticLogs"
  name                    = "AHDSMedTechDiagnosticLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-152" {
  description             = ""
  display_name            = "AKSAudit"
  name                    = "AKSAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-153" {
  description             = ""
  display_name            = "AKSAuditAdmin"
  name                    = "AKSAuditAdmin"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-154" {
  description             = ""
  display_name            = "AKSControlPlane"
  name                    = "AKSControlPlane"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-155" {
  description             = ""
  display_name            = "ALBHealthEvent"
  name                    = "ALBHealthEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-156" {
  description             = ""
  display_name            = "AMAHealth"
  name                    = "AMAHealth"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-157" {
  description             = ""
  display_name            = "AMSKeyDeliveryRequests"
  name                    = "AMSKeyDeliveryRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-158" {
  description             = ""
  display_name            = "AMSLiveEventOperations"
  name                    = "AMSLiveEventOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-159" {
  description             = ""
  display_name            = "AMSMediaAccountHealth"
  name                    = "AMSMediaAccountHealth"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-160" {
  description             = ""
  display_name            = "AMSStreamingEndpointRequests"
  name                    = "AMSStreamingEndpointRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-161" {
  description             = ""
  display_name            = "AMWMetricsUsageDetails"
  name                    = "AMWMetricsUsageDetails"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-162" {
  description             = ""
  display_name            = "ANFFileAccess"
  name                    = "ANFFileAccess"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-163" {
  description             = ""
  display_name            = "ANFTopClientReadIOPS"
  name                    = "ANFTopClientReadIOPS"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-164" {
  description             = ""
  display_name            = "ANFTopClientWriteIOPS"
  name                    = "ANFTopClientWriteIOPS"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-165" {
  description             = ""
  display_name            = "ANFTopFileReadIOPS"
  name                    = "ANFTopFileReadIOPS"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-166" {
  description             = ""
  display_name            = "ANFTopFileWriteIOPS"
  name                    = "ANFTopFileWriteIOPS"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-167" {
  description             = ""
  display_name            = "AOIDatabaseQuery"
  name                    = "AOIDatabaseQuery"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-168" {
  description             = ""
  display_name            = "AOIDigestion"
  name                    = "AOIDigestion"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-169" {
  description             = ""
  display_name            = "AOIStorage"
  name                    = "AOIStorage"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-170" {
  description             = ""
  display_name            = "APIMDevPortalAuditDiagnosticLog"
  name                    = "APIMDevPortalAuditDiagnosticLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-171" {
  description             = ""
  display_name            = "ASCAuditLogs"
  name                    = "ASCAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-172" {
  description             = ""
  display_name            = "ASCDeviceEvents"
  name                    = "ASCDeviceEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-173" {
  description             = ""
  display_name            = "ASRJobs"
  name                    = "ASRJobs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-174" {
  description             = ""
  display_name            = "ASRReplicatedItems"
  name                    = "ASRReplicatedItems"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-175" {
  description             = ""
  display_name            = "ASRv2HealthEvents"
  name                    = "ASRv2HealthEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-176" {
  description             = ""
  display_name            = "ASRv2JobEvents"
  name                    = "ASRv2JobEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-177" {
  description             = ""
  display_name            = "ASRv2ProtectedItems"
  name                    = "ASRv2ProtectedItems"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-178" {
  description             = ""
  display_name            = "ASRv2ReplicationExtensions"
  name                    = "ASRv2ReplicationExtensions"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-179" {
  description             = ""
  display_name            = "ASRv2ReplicationPolicies"
  name                    = "ASRv2ReplicationPolicies"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-180" {
  description             = ""
  display_name            = "ASRv2ReplicationVaults"
  name                    = "ASRv2ReplicationVaults"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-181" {
  description             = ""
  display_name            = "ATCExpressRouteCircuitIpfix"
  name                    = "ATCExpressRouteCircuitIpfix"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-182" {
  description             = ""
  display_name            = "ATCMicrosoftPeeringMetadata"
  name                    = "ATCMicrosoftPeeringMetadata"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-183" {
  description             = ""
  display_name            = "ATCPrivatePeeringMetadata"
  name                    = "ATCPrivatePeeringMetadata"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-184" {
  description             = ""
  display_name            = "AVNMConnectivityConfigurationChange"
  name                    = "AVNMConnectivityConfigurationChange"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-185" {
  description             = ""
  display_name            = "AVNMIPAMPoolAllocationChange"
  name                    = "AVNMIPAMPoolAllocationChange"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-186" {
  description             = ""
  display_name            = "AVNMNetworkGroupMembershipChange"
  name                    = "AVNMNetworkGroupMembershipChange"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-187" {
  description             = ""
  display_name            = "AVNMRuleCollectionChange"
  name                    = "AVNMRuleCollectionChange"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-188" {
  description             = ""
  display_name            = "AVSEsxiFirewallSyslog"
  name                    = "AVSEsxiFirewallSyslog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-189" {
  description             = ""
  display_name            = "AVSEsxiSyslog"
  name                    = "AVSEsxiSyslog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-190" {
  description             = ""
  display_name            = "AVSNsxEdgeSyslog"
  name                    = "AVSNsxEdgeSyslog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-191" {
  description             = ""
  display_name            = "AVSNsxManagerSyslog"
  name                    = "AVSNsxManagerSyslog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-192" {
  description             = ""
  display_name            = "AVSSyslog"
  name                    = "AVSSyslog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-193" {
  description             = ""
  display_name            = "AVSVcSyslog"
  name                    = "AVSVcSyslog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-194" {
  description             = ""
  display_name            = "AZFWApplicationRule"
  name                    = "AZFWApplicationRule"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-195" {
  description             = ""
  display_name            = "AZFWApplicationRuleAggregation"
  name                    = "AZFWApplicationRuleAggregation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-196" {
  description             = ""
  display_name            = "AZFWDnsFlowTrace"
  name                    = "AZFWDnsFlowTrace"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-197" {
  description             = ""
  display_name            = "AZFWDnsQuery"
  name                    = "AZFWDnsQuery"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-198" {
  description             = ""
  display_name            = "AZFWFatFlow"
  name                    = "AZFWFatFlow"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-199" {
  description             = ""
  display_name            = "AZFWFlowTrace"
  name                    = "AZFWFlowTrace"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-200" {
  description             = ""
  display_name            = "AZFWIdpsSignature"
  name                    = "AZFWIdpsSignature"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-201" {
  description             = ""
  display_name            = "AZFWInternalFqdnResolutionFailure"
  name                    = "AZFWInternalFqdnResolutionFailure"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-202" {
  description             = ""
  display_name            = "AZFWNatRule"
  name                    = "AZFWNatRule"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-203" {
  description             = ""
  display_name            = "AZFWNatRuleAggregation"
  name                    = "AZFWNatRuleAggregation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-204" {
  description             = ""
  display_name            = "AZFWNetworkRule"
  name                    = "AZFWNetworkRule"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-205" {
  description             = ""
  display_name            = "AZFWNetworkRuleAggregation"
  name                    = "AZFWNetworkRuleAggregation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-206" {
  description             = ""
  display_name            = "AZFWThreatIntel"
  name                    = "AZFWThreatIntel"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-207" {
  description             = ""
  display_name            = "AZKVAuditLogs"
  name                    = "AZKVAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-208" {
  description             = ""
  display_name            = "AZKVPolicyEvaluationDetailsLogs"
  name                    = "AZKVPolicyEvaluationDetailsLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-209" {
  description             = ""
  display_name            = "AZMSApplicationMetricLogs"
  name                    = "AZMSApplicationMetricLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-210" {
  description             = ""
  display_name            = "AZMSArchiveLogs"
  name                    = "AZMSArchiveLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-211" {
  description             = ""
  display_name            = "AZMSAutoscaleLogs"
  name                    = "AZMSAutoscaleLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-212" {
  description             = ""
  display_name            = "AZMSCustomerManagedKeyUserLogs"
  name                    = "AZMSCustomerManagedKeyUserLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-213" {
  description             = ""
  display_name            = "AZMSDiagnosticErrorLogs"
  name                    = "AZMSDiagnosticErrorLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-214" {
  description             = ""
  display_name            = "AZMSHybridConnectionsEvents"
  name                    = "AZMSHybridConnectionsEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-215" {
  description             = ""
  display_name            = "AZMSKafkaCoordinatorLogs"
  name                    = "AZMSKafkaCoordinatorLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-216" {
  description             = ""
  display_name            = "AZMSKafkaUserErrorLogs"
  name                    = "AZMSKafkaUserErrorLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-217" {
  description             = ""
  display_name            = "AZMSOperationalLogs"
  name                    = "AZMSOperationalLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-218" {
  description             = ""
  display_name            = "AZMSRunTimeAuditLogs"
  name                    = "AZMSRunTimeAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-219" {
  description             = ""
  display_name            = "AZMSVnetConnectionEvents"
  name                    = "AZMSVnetConnectionEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-220" {
  description             = ""
  display_name            = "AddonAzureBackupAlerts"
  name                    = "AddonAzureBackupAlerts"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-221" {
  description             = ""
  display_name            = "AddonAzureBackupJobs"
  name                    = "AddonAzureBackupJobs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-222" {
  description             = ""
  display_name            = "AddonAzureBackupPolicy"
  name                    = "AddonAzureBackupPolicy"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-223" {
  description             = ""
  display_name            = "AddonAzureBackupProtectedInstance"
  name                    = "AddonAzureBackupProtectedInstance"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-224" {
  description             = ""
  display_name            = "AddonAzureBackupStorage"
  name                    = "AddonAzureBackupStorage"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-225" {
  description             = ""
  display_name            = "AegDataPlaneRequests"
  name                    = "AegDataPlaneRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-226" {
  description             = ""
  display_name            = "AegDeliveryFailureLogs"
  name                    = "AegDeliveryFailureLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-227" {
  description             = ""
  display_name            = "AegPublishFailureLogs"
  name                    = "AegPublishFailureLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-228" {
  description             = ""
  display_name            = "AgriFoodApplicationAuditLogs"
  name                    = "AgriFoodApplicationAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-229" {
  description             = ""
  display_name            = "AgriFoodFarmManagementLogs"
  name                    = "AgriFoodFarmManagementLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-230" {
  description             = ""
  display_name            = "AgriFoodFarmOperationLogs"
  name                    = "AgriFoodFarmOperationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-231" {
  description             = ""
  display_name            = "AgriFoodInsightLogs"
  name                    = "AgriFoodInsightLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-232" {
  description             = ""
  display_name            = "AgriFoodJobProcessedLogs"
  name                    = "AgriFoodJobProcessedLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-233" {
  description             = ""
  display_name            = "AgriFoodModelInferenceLogs"
  name                    = "AgriFoodModelInferenceLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-234" {
  description             = ""
  display_name            = "AgriFoodProviderAuthLogs"
  name                    = "AgriFoodProviderAuthLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-235" {
  description             = ""
  display_name            = "AgriFoodSatelliteLogs"
  name                    = "AgriFoodSatelliteLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-236" {
  description             = ""
  display_name            = "AgriFoodSensorManagementLogs"
  name                    = "AgriFoodSensorManagementLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-237" {
  description             = ""
  display_name            = "AgriFoodWeatherLogs"
  name                    = "AgriFoodWeatherLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-238" {
  description             = ""
  display_name            = "AirflowDagProcessingLogs"
  name                    = "AirflowDagProcessingLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-239" {
  description             = ""
  display_name            = "Alert"
  name                    = "Alert"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-240" {
  description             = ""
  display_name            = "AmlComputeClusterEvent"
  name                    = "AmlComputeClusterEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-241" {
  description             = ""
  display_name            = "AmlComputeClusterNodeEvent"
  name                    = "AmlComputeClusterNodeEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-242" {
  description             = ""
  display_name            = "AmlComputeCpuGpuUtilization"
  name                    = "AmlComputeCpuGpuUtilization"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-243" {
  description             = ""
  display_name            = "AmlComputeInstanceEvent"
  name                    = "AmlComputeInstanceEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-244" {
  description             = ""
  display_name            = "AmlComputeJobEvent"
  name                    = "AmlComputeJobEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-245" {
  description             = ""
  display_name            = "AmlDataLabelEvent"
  name                    = "AmlDataLabelEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-246" {
  description             = ""
  display_name            = "AmlDataSetEvent"
  name                    = "AmlDataSetEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-247" {
  description             = ""
  display_name            = "AmlDataStoreEvent"
  name                    = "AmlDataStoreEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-248" {
  description             = ""
  display_name            = "AmlDeploymentEvent"
  name                    = "AmlDeploymentEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-249" {
  description             = ""
  display_name            = "AmlEnvironmentEvent"
  name                    = "AmlEnvironmentEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-250" {
  description             = ""
  display_name            = "AmlInferencingEvent"
  name                    = "AmlInferencingEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-251" {
  description             = ""
  display_name            = "AmlModelsEvent"
  name                    = "AmlModelsEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-252" {
  description             = ""
  display_name            = "AmlOnlineEndpointConsoleLog"
  name                    = "AmlOnlineEndpointConsoleLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-253" {
  description             = ""
  display_name            = "AmlOnlineEndpointEventLog"
  name                    = "AmlOnlineEndpointEventLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-254" {
  description             = ""
  display_name            = "AmlOnlineEndpointTrafficLog"
  name                    = "AmlOnlineEndpointTrafficLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-255" {
  description             = ""
  display_name            = "AmlPipelineEvent"
  name                    = "AmlPipelineEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-256" {
  description             = ""
  display_name            = "AmlRegistryReadEventsLog"
  name                    = "AmlRegistryReadEventsLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-257" {
  description             = ""
  display_name            = "AmlRegistryWriteEventsLog"
  name                    = "AmlRegistryWriteEventsLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-258" {
  description             = ""
  display_name            = "AmlRunEvent"
  name                    = "AmlRunEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-259" {
  description             = ""
  display_name            = "AmlRunStatusChangedEvent"
  name                    = "AmlRunStatusChangedEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-260" {
  description             = ""
  display_name            = "ApiManagementGatewayLlmLog"
  name                    = "ApiManagementGatewayLlmLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-261" {
  description             = ""
  display_name            = "ApiManagementGatewayLogs"
  name                    = "ApiManagementGatewayLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-262" {
  description             = ""
  display_name            = "ApiManagementGatewayMCPLog"
  name                    = "ApiManagementGatewayMCPLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-263" {
  description             = ""
  display_name            = "ApiManagementWebSocketConnectionLogs"
  name                    = "ApiManagementWebSocketConnectionLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-264" {
  description             = ""
  display_name            = "AppAvailabilityResults"
  name                    = "AppAvailabilityResults"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-265" {
  description             = ""
  display_name            = "AppBrowserTimings"
  name                    = "AppBrowserTimings"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-266" {
  description             = ""
  display_name            = "AppCenterError"
  name                    = "AppCenterError"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-267" {
  description             = ""
  display_name            = "AppDependencies"
  name                    = "AppDependencies"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-268" {
  description             = ""
  display_name            = "AppEnvSessionConsoleLogs"
  name                    = "AppEnvSessionConsoleLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-269" {
  description             = ""
  display_name            = "AppEnvSessionLifecycleLogs"
  name                    = "AppEnvSessionLifecycleLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-270" {
  description             = ""
  display_name            = "AppEnvSessionPoolEventLogs"
  name                    = "AppEnvSessionPoolEventLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-271" {
  description             = ""
  display_name            = "AppEnvSpringAppConsoleLogs"
  name                    = "AppEnvSpringAppConsoleLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-272" {
  description             = ""
  display_name            = "AppEvents"
  name                    = "AppEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-273" {
  description             = ""
  display_name            = "AppExceptions"
  name                    = "AppExceptions"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-274" {
  description             = ""
  display_name            = "AppGenAIContent"
  name                    = "AppGenAIContent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-275" {
  description             = ""
  display_name            = "AppMetrics"
  name                    = "AppMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-276" {
  description             = ""
  display_name            = "AppPageViews"
  name                    = "AppPageViews"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-277" {
  description             = ""
  display_name            = "AppPerformanceCounters"
  name                    = "AppPerformanceCounters"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-278" {
  description             = ""
  display_name            = "AppPlatformBuildLogs"
  name                    = "AppPlatformBuildLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-279" {
  description             = ""
  display_name            = "AppPlatformContainerEventLogs"
  name                    = "AppPlatformContainerEventLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-280" {
  description             = ""
  display_name            = "AppPlatformIngressLogs"
  name                    = "AppPlatformIngressLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-281" {
  description             = ""
  display_name            = "AppPlatformLogsforSpring"
  name                    = "AppPlatformLogsforSpring"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-282" {
  description             = ""
  display_name            = "AppPlatformSystemLogs"
  name                    = "AppPlatformSystemLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-283" {
  description             = ""
  display_name            = "AppRequests"
  name                    = "AppRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-284" {
  description             = ""
  display_name            = "AppServiceAntivirusScanAuditLogs"
  name                    = "AppServiceAntivirusScanAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-285" {
  description             = ""
  display_name            = "AppServiceAppLogs"
  name                    = "AppServiceAppLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-286" {
  description             = ""
  display_name            = "AppServiceAuditLogs"
  name                    = "AppServiceAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-287" {
  description             = ""
  display_name            = "AppServiceAuthenticationLogs"
  name                    = "AppServiceAuthenticationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-288" {
  description             = ""
  display_name            = "AppServiceConsoleLogs"
  name                    = "AppServiceConsoleLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-289" {
  description             = ""
  display_name            = "AppServiceEnvironmentPlatformLogs"
  name                    = "AppServiceEnvironmentPlatformLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-290" {
  description             = ""
  display_name            = "AppServiceFileAuditLogs"
  name                    = "AppServiceFileAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-291" {
  description             = ""
  display_name            = "AppServiceHTTPLogs"
  name                    = "AppServiceHTTPLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-292" {
  description             = ""
  display_name            = "AppServiceIPSecAuditLogs"
  name                    = "AppServiceIPSecAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-293" {
  description             = ""
  display_name            = "AppServicePlatformLogs"
  name                    = "AppServicePlatformLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-294" {
  description             = ""
  display_name            = "AppServiceServerlessSecurityPluginData"
  name                    = "AppServiceServerlessSecurityPluginData"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-295" {
  description             = ""
  display_name            = "AppSystemEvents"
  name                    = "AppSystemEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-296" {
  description             = ""
  display_name            = "AppTraces"
  name                    = "AppTraces"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-297" {
  description             = ""
  display_name            = "ArcK8sAudit"
  name                    = "ArcK8sAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-298" {
  description             = ""
  display_name            = "ArcK8sAuditAdmin"
  name                    = "ArcK8sAuditAdmin"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-299" {
  description             = ""
  display_name            = "ArcK8sControlPlane"
  name                    = "ArcK8sControlPlane"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-300" {
  description             = ""
  display_name            = "AuditLogs"
  name                    = "AuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-301" {
  description             = ""
  display_name            = "AutoscaleEvaluationsLog"
  name                    = "AutoscaleEvaluationsLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-302" {
  description             = ""
  display_name            = "AutoscaleScaleActionsLog"
  name                    = "AutoscaleScaleActionsLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-303" {
  description             = ""
  display_name            = "AzureActivity"
  name                    = "AzureActivity"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-304" {
  description             = ""
  display_name            = "AzureActivityV2"
  name                    = "AzureActivityV2"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-305" {
  description             = ""
  display_name            = "AzureAssessmentRecommendation"
  name                    = "AzureAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-306" {
  description             = ""
  display_name            = "AzureAttestationDiagnostics"
  name                    = "AzureAttestationDiagnostics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-307" {
  description             = ""
  display_name            = "AzureBackupOperations"
  name                    = "AzureBackupOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-308" {
  description             = ""
  display_name            = "AzureDevOpsAuditing"
  name                    = "AzureDevOpsAuditing"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-309" {
  description             = ""
  display_name            = "AzureLoadTestingOperation"
  name                    = "AzureLoadTestingOperation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-310" {
  description             = ""
  display_name            = "AzureMetrics"
  name                    = "AzureMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-311" {
  description             = ""
  display_name            = "AzureMetricsV2"
  name                    = "AzureMetricsV2"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-312" {
  description             = ""
  display_name            = "AzureMonitorPipelineLogErrors"
  name                    = "AzureMonitorPipelineLogErrors"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-313" {
  description             = ""
  display_name            = "AzureSQLAutomaticTuning"
  name                    = "AzureSQLAutomaticTuning"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-314" {
  description             = ""
  display_name            = "AzureSQLBlocks"
  name                    = "AzureSQLBlocks"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-315" {
  description             = ""
  display_name            = "AzureSQLDatabaseWaitStatistics"
  name                    = "AzureSQLDatabaseWaitStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-316" {
  description             = ""
  display_name            = "AzureSQLDeadlocks"
  name                    = "AzureSQLDeadlocks"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-317" {
  description             = ""
  display_name            = "AzureSQLErrors"
  name                    = "AzureSQLErrors"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-318" {
  description             = ""
  display_name            = "AzureSQLQueryStoreRuntimeStatistics"
  name                    = "AzureSQLQueryStoreRuntimeStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-319" {
  description             = ""
  display_name            = "AzureSQLQueryStoreWaitStatistics"
  name                    = "AzureSQLQueryStoreWaitStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-320" {
  description             = ""
  display_name            = "AzureSQLResourceUsageStats"
  name                    = "AzureSQLResourceUsageStats"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-321" {
  description             = ""
  display_name            = "AzureSQLTimeouts"
  name                    = "AzureSQLTimeouts"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-322" {
  description             = ""
  display_name            = "BehaviorEntities"
  name                    = "BehaviorEntities"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-323" {
  description             = ""
  display_name            = "BehaviorInfo"
  name                    = "BehaviorInfo"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-324" {
  description             = ""
  display_name            = "BlockchainApplicationLog"
  name                    = "BlockchainApplicationLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-325" {
  description             = ""
  display_name            = "BlockchainProxyLog"
  name                    = "BlockchainProxyLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-326" {
  description             = ""
  display_name            = "CCFApplicationLogs"
  name                    = "CCFApplicationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-327" {
  description             = ""
  display_name            = "CDBCassandraRequests"
  name                    = "CDBCassandraRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-328" {
  description             = ""
  display_name            = "CDBControlPlaneRequests"
  name                    = "CDBControlPlaneRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-329" {
  description             = ""
  display_name            = "CDBDataPlaneRequests"
  name                    = "CDBDataPlaneRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-330" {
  description             = ""
  display_name            = "CDBDataPlaneRequests15M"
  name                    = "CDBDataPlaneRequests15M"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-331" {
  description             = ""
  display_name            = "CDBDataPlaneRequests5M"
  name                    = "CDBDataPlaneRequests5M"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-332" {
  description             = ""
  display_name            = "CDBGremlinRequests"
  name                    = "CDBGremlinRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-333" {
  description             = ""
  display_name            = "CDBMongoRequests"
  name                    = "CDBMongoRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-334" {
  description             = ""
  display_name            = "CDBPartitionKeyRUConsumption"
  name                    = "CDBPartitionKeyRUConsumption"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-335" {
  description             = ""
  display_name            = "CDBPartitionKeyStatistics"
  name                    = "CDBPartitionKeyStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-336" {
  description             = ""
  display_name            = "CDBQueryRuntimeStatistics"
  name                    = "CDBQueryRuntimeStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-337" {
  description             = ""
  display_name            = "CDBTableApiRequests"
  name                    = "CDBTableApiRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-338" {
  description             = ""
  display_name            = "CHSMServiceOperationAuditLogs"
  name                    = "CHSMServiceOperationAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-339" {
  description             = ""
  display_name            = "CIEventsAudit"
  name                    = "CIEventsAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-340" {
  description             = ""
  display_name            = "CIEventsOperational"
  name                    = "CIEventsOperational"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-341" {
  description             = ""
  display_name            = "CassandraAudit"
  name                    = "CassandraAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-342" {
  description             = ""
  display_name            = "CassandraLogs"
  name                    = "CassandraLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-343" {
  description             = ""
  display_name            = "ChaosStudioExperimentEventLogs"
  name                    = "ChaosStudioExperimentEventLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-344" {
  description             = ""
  display_name            = "CloudHsmHardwareOperationAuditLogs"
  name                    = "CloudHsmHardwareOperationAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-345" {
  description             = ""
  display_name            = "CloudHsmServiceOperationAuditLogs"
  name                    = "CloudHsmServiceOperationAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-346" {
  description             = ""
  display_name            = "ComputerGroup"
  name                    = "ComputerGroup"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-347" {
  description             = ""
  display_name            = "ContainerAppConsoleLogs"
  name                    = "ContainerAppConsoleLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-348" {
  description             = ""
  display_name            = "ContainerAppHTTPLogs"
  name                    = "ContainerAppHTTPLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-349" {
  description             = ""
  display_name            = "ContainerAppSystemLogs"
  name                    = "ContainerAppSystemLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-350" {
  description             = ""
  display_name            = "ContainerEvent"
  name                    = "ContainerEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-351" {
  description             = ""
  display_name            = "ContainerImageInventory"
  name                    = "ContainerImageInventory"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-352" {
  description             = ""
  display_name            = "ContainerInstanceLog"
  name                    = "ContainerInstanceLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-353" {
  description             = ""
  display_name            = "ContainerInventory"
  name                    = "ContainerInventory"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-354" {
  description             = ""
  display_name            = "ContainerLog"
  name                    = "ContainerLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-355" {
  description             = ""
  display_name            = "ContainerLogV2"
  name                    = "ContainerLogV2"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-356" {
  description             = ""
  display_name            = "ContainerNetworkLogs"
  name                    = "ContainerNetworkLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-357" {
  description             = ""
  display_name            = "ContainerNodeInventory"
  name                    = "ContainerNodeInventory"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-358" {
  description             = ""
  display_name            = "ContainerRegistryLoginEvents"
  name                    = "ContainerRegistryLoginEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-359" {
  description             = ""
  display_name            = "ContainerRegistryRepositoryEvents"
  name                    = "ContainerRegistryRepositoryEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-360" {
  description             = ""
  display_name            = "ContainerServiceLog"
  name                    = "ContainerServiceLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-361" {
  description             = ""
  display_name            = "CoreAzureBackup"
  name                    = "CoreAzureBackup"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-362" {
  description             = ""
  display_name            = "DCRLogErrors"
  name                    = "DCRLogErrors"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-363" {
  description             = ""
  display_name            = "DCRLogTroubleshooting"
  name                    = "DCRLogTroubleshooting"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-364" {
  description             = ""
  display_name            = "DNSQueryLogs"
  name                    = "DNSQueryLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-365" {
  description             = ""
  display_name            = "DSMAzureBlobStorageLogs"
  name                    = "DSMAzureBlobStorageLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-366" {
  description             = ""
  display_name            = "DSMDataClassificationLogs"
  name                    = "DSMDataClassificationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-367" {
  description             = ""
  display_name            = "DSMDataLabelingLogs"
  name                    = "DSMDataLabelingLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-368" {
  description             = ""
  display_name            = "DataSetOutput"
  name                    = "DataSetOutput"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-369" {
  description             = ""
  display_name            = "DataSetRuns"
  name                    = "DataSetRuns"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-370" {
  description             = ""
  display_name            = "DataTransferOperations"
  name                    = "DataTransferOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-371" {
  description             = ""
  display_name            = "DatabricksAccounts"
  name                    = "DatabricksAccounts"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-372" {
  description             = ""
  display_name            = "DatabricksApps"
  name                    = "DatabricksApps"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-373" {
  description             = ""
  display_name            = "DatabricksBrickStoreHttpGateway"
  name                    = "DatabricksBrickStoreHttpGateway"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-374" {
  description             = ""
  display_name            = "DatabricksBudgetPolicyCentral"
  name                    = "DatabricksBudgetPolicyCentral"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-375" {
  description             = ""
  display_name            = "DatabricksCapsule8Dataplane"
  name                    = "DatabricksCapsule8Dataplane"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-376" {
  description             = ""
  display_name            = "DatabricksClamAVScan"
  name                    = "DatabricksClamAVScan"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-377" {
  description             = ""
  display_name            = "DatabricksCloudStorageMetadata"
  name                    = "DatabricksCloudStorageMetadata"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-378" {
  description             = ""
  display_name            = "DatabricksClusterLibraries"
  name                    = "DatabricksClusterLibraries"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-379" {
  description             = ""
  display_name            = "DatabricksClusterPolicies"
  name                    = "DatabricksClusterPolicies"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-380" {
  description             = ""
  display_name            = "DatabricksClusters"
  name                    = "DatabricksClusters"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-381" {
  description             = ""
  display_name            = "DatabricksDBFS"
  name                    = "DatabricksDBFS"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-382" {
  description             = ""
  display_name            = "DatabricksDashboards"
  name                    = "DatabricksDashboards"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-383" {
  description             = ""
  display_name            = "DatabricksDataMonitoring"
  name                    = "DatabricksDataMonitoring"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-384" {
  description             = ""
  display_name            = "DatabricksDataRooms"
  name                    = "DatabricksDataRooms"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-385" {
  description             = ""
  display_name            = "DatabricksDatabricksSQL"
  name                    = "DatabricksDatabricksSQL"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-386" {
  description             = ""
  display_name            = "DatabricksDeltaPipelines"
  name                    = "DatabricksDeltaPipelines"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-387" {
  description             = ""
  display_name            = "DatabricksFeatureStore"
  name                    = "DatabricksFeatureStore"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-388" {
  description             = ""
  display_name            = "DatabricksFiles"
  name                    = "DatabricksFiles"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-389" {
  description             = ""
  display_name            = "DatabricksFilesystem"
  name                    = "DatabricksFilesystem"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-390" {
  description             = ""
  display_name            = "DatabricksGenie"
  name                    = "DatabricksGenie"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-391" {
  description             = ""
  display_name            = "DatabricksGitCredentials"
  name                    = "DatabricksGitCredentials"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-392" {
  description             = ""
  display_name            = "DatabricksGlobalInitScripts"
  name                    = "DatabricksGlobalInitScripts"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-393" {
  description             = ""
  display_name            = "DatabricksGroups"
  name                    = "DatabricksGroups"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-394" {
  description             = ""
  display_name            = "DatabricksIAMRole"
  name                    = "DatabricksIAMRole"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-395" {
  description             = ""
  display_name            = "DatabricksIngestion"
  name                    = "DatabricksIngestion"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-396" {
  description             = ""
  display_name            = "DatabricksInstancePools"
  name                    = "DatabricksInstancePools"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-397" {
  description             = ""
  display_name            = "DatabricksJobs"
  name                    = "DatabricksJobs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-398" {
  description             = ""
  display_name            = "DatabricksLakeviewConfig"
  name                    = "DatabricksLakeviewConfig"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-399" {
  description             = ""
  display_name            = "DatabricksLineageTracking"
  name                    = "DatabricksLineageTracking"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-400" {
  description             = ""
  display_name            = "DatabricksMLflowAcledArtifact"
  name                    = "DatabricksMLflowAcledArtifact"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-401" {
  description             = ""
  display_name            = "DatabricksMLflowExperiment"
  name                    = "DatabricksMLflowExperiment"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-402" {
  description             = ""
  display_name            = "DatabricksMarketplaceConsumer"
  name                    = "DatabricksMarketplaceConsumer"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-403" {
  description             = ""
  display_name            = "DatabricksMarketplaceProvider"
  name                    = "DatabricksMarketplaceProvider"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-404" {
  description             = ""
  display_name            = "DatabricksModelRegistry"
  name                    = "DatabricksModelRegistry"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-405" {
  description             = ""
  display_name            = "DatabricksNotebook"
  name                    = "DatabricksNotebook"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-406" {
  description             = ""
  display_name            = "DatabricksOnlineTables"
  name                    = "DatabricksOnlineTables"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-407" {
  description             = ""
  display_name            = "DatabricksPartnerHub"
  name                    = "DatabricksPartnerHub"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-408" {
  description             = ""
  display_name            = "DatabricksPredictiveOptimization"
  name                    = "DatabricksPredictiveOptimization"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-409" {
  description             = ""
  display_name            = "DatabricksRBAC"
  name                    = "DatabricksRBAC"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-410" {
  description             = ""
  display_name            = "DatabricksRFA"
  name                    = "DatabricksRFA"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-411" {
  description             = ""
  display_name            = "DatabricksRemoteHistoryService"
  name                    = "DatabricksRemoteHistoryService"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-412" {
  description             = ""
  display_name            = "DatabricksRepos"
  name                    = "DatabricksRepos"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-413" {
  description             = ""
  display_name            = "DatabricksSQL"
  name                    = "DatabricksSQL"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-414" {
  description             = ""
  display_name            = "DatabricksSQLPermissions"
  name                    = "DatabricksSQLPermissions"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-415" {
  description             = ""
  display_name            = "DatabricksSSH"
  name                    = "DatabricksSSH"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-416" {
  description             = ""
  display_name            = "DatabricksSecrets"
  name                    = "DatabricksSecrets"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-417" {
  description             = ""
  display_name            = "DatabricksServerlessRealTimeInference"
  name                    = "DatabricksServerlessRealTimeInference"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-418" {
  description             = ""
  display_name            = "DatabricksTables"
  name                    = "DatabricksTables"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-419" {
  description             = ""
  display_name            = "DatabricksUnityCatalog"
  name                    = "DatabricksUnityCatalog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-420" {
  description             = ""
  display_name            = "DatabricksVectorSearch"
  name                    = "DatabricksVectorSearch"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-421" {
  description             = ""
  display_name            = "DatabricksWebTerminal"
  name                    = "DatabricksWebTerminal"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-422" {
  description             = ""
  display_name            = "DatabricksWebhookNotifications"
  name                    = "DatabricksWebhookNotifications"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-423" {
  description             = ""
  display_name            = "DatabricksWorkspace"
  name                    = "DatabricksWorkspace"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-424" {
  description             = ""
  display_name            = "DatabricksWorkspaceFiles"
  name                    = "DatabricksWorkspaceFiles"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-425" {
  description             = ""
  display_name            = "DevCenterAgentHealthLogs"
  name                    = "DevCenterAgentHealthLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-426" {
  description             = ""
  display_name            = "DevCenterBillingEventLogs"
  name                    = "DevCenterBillingEventLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-427" {
  description             = ""
  display_name            = "DevCenterConnectionLogs"
  name                    = "DevCenterConnectionLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-428" {
  description             = ""
  display_name            = "DevCenterDiagnosticLogs"
  name                    = "DevCenterDiagnosticLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-429" {
  description             = ""
  display_name            = "DevCenterResourceOperationLogs"
  name                    = "DevCenterResourceOperationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-430" {
  description             = ""
  display_name            = "DevOpsOperationsAudit"
  name                    = "DevOpsOperationsAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-431" {
  description             = ""
  display_name            = "DeviceBehaviorEntities"
  name                    = "DeviceBehaviorEntities"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-432" {
  description             = ""
  display_name            = "DeviceBehaviorInfo"
  name                    = "DeviceBehaviorInfo"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-433" {
  description             = ""
  display_name            = "DeviceCustomFileEvents"
  name                    = "DeviceCustomFileEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-434" {
  description             = ""
  display_name            = "DeviceCustomImageLoadEvents"
  name                    = "DeviceCustomImageLoadEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-435" {
  description             = ""
  display_name            = "DeviceCustomNetworkEvents"
  name                    = "DeviceCustomNetworkEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-436" {
  description             = ""
  display_name            = "DeviceCustomProcessEvents"
  name                    = "DeviceCustomProcessEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-437" {
  description             = ""
  display_name            = "DeviceCustomRegistryEvents"
  name                    = "DeviceCustomRegistryEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-438" {
  description             = ""
  display_name            = "DeviceCustomScriptEvents"
  name                    = "DeviceCustomScriptEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-439" {
  description             = ""
  display_name            = "DiscoveryBookshelfAuditLogs"
  name                    = "DiscoveryBookshelfAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-440" {
  description             = ""
  display_name            = "DiscoverySupercomputerAuditLogs"
  name                    = "DiscoverySupercomputerAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-441" {
  description             = ""
  display_name            = "DiscoveryWorkspaceAuditLogs"
  name                    = "DiscoveryWorkspaceAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-442" {
  description             = ""
  display_name            = "DragonCopilot"
  name                    = "DragonCopilot"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-443" {
  description             = ""
  display_name            = "DurableTaskSchedulerLogs"
  name                    = "DurableTaskSchedulerLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-444" {
  description             = ""
  display_name            = "EGNFailedHttpDataPlaneOperations"
  name                    = "EGNFailedHttpDataPlaneOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-445" {
  description             = ""
  display_name            = "EGNFailedMqttConnections"
  name                    = "EGNFailedMqttConnections"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-446" {
  description             = ""
  display_name            = "EGNFailedMqttPublishedMessages"
  name                    = "EGNFailedMqttPublishedMessages"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-447" {
  description             = ""
  display_name            = "EGNFailedMqttSubscriptions"
  name                    = "EGNFailedMqttSubscriptions"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-448" {
  description             = ""
  display_name            = "EGNMqttDisconnections"
  name                    = "EGNMqttDisconnections"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-449" {
  description             = ""
  display_name            = "EGNSuccessfulHttpDataPlaneOperations"
  name                    = "EGNSuccessfulHttpDataPlaneOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-450" {
  description             = ""
  display_name            = "EGNSuccessfulMqttConnections"
  name                    = "EGNSuccessfulMqttConnections"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-451" {
  description             = ""
  display_name            = "ETWEvent"
  name                    = "ETWEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-452" {
  description             = ""
  display_name            = "EdgeActionConsoleLog"
  name                    = "EdgeActionConsoleLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-453" {
  description             = ""
  display_name            = "EdgeActionServiceLog"
  name                    = "EdgeActionServiceLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-454" {
  description             = ""
  display_name            = "EnrichedMicrosoft365AuditLogs"
  name                    = "EnrichedMicrosoft365AuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-455" {
  description             = ""
  display_name            = "Event"
  name                    = "Event"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-456" {
  description             = ""
  display_name            = "ExchangeAssessmentRecommendation"
  name                    = "ExchangeAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-457" {
  description             = ""
  display_name            = "ExchangeOnlineAssessmentRecommendation"
  name                    = "ExchangeOnlineAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-458" {
  description             = ""
  display_name            = "FailedIngestion"
  name                    = "FailedIngestion"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-459" {
  description             = ""
  display_name            = "FunctionAppLogs"
  name                    = "FunctionAppLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-460" {
  description             = ""
  display_name            = "GraphNotificationsActivityLogs"
  name                    = "GraphNotificationsActivityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-461" {
  description             = ""
  display_name            = "HDInsightAmbariClusterAlerts"
  name                    = "HDInsightAmbariClusterAlerts"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-462" {
  description             = ""
  display_name            = "HDInsightAmbariSystemMetrics"
  name                    = "HDInsightAmbariSystemMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-463" {
  description             = ""
  display_name            = "HDInsightGatewayAuditLogs"
  name                    = "HDInsightGatewayAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-464" {
  description             = ""
  display_name            = "HDInsightHBaseLogs"
  name                    = "HDInsightHBaseLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-465" {
  description             = ""
  display_name            = "HDInsightHBaseMetrics"
  name                    = "HDInsightHBaseMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-466" {
  description             = ""
  display_name            = "HDInsightHadoopAndYarnLogs"
  name                    = "HDInsightHadoopAndYarnLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-467" {
  description             = ""
  display_name            = "HDInsightHadoopAndYarnMetrics"
  name                    = "HDInsightHadoopAndYarnMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-468" {
  description             = ""
  display_name            = "HDInsightHiveAndLLAPLogs"
  name                    = "HDInsightHiveAndLLAPLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-469" {
  description             = ""
  display_name            = "HDInsightHiveAndLLAPMetrics"
  name                    = "HDInsightHiveAndLLAPMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-470" {
  description             = ""
  display_name            = "HDInsightHiveQueryAppStats"
  name                    = "HDInsightHiveQueryAppStats"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-471" {
  description             = ""
  display_name            = "HDInsightHiveTezAppStats"
  name                    = "HDInsightHiveTezAppStats"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-472" {
  description             = ""
  display_name            = "HDInsightJupyterNotebookEvents"
  name                    = "HDInsightJupyterNotebookEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-473" {
  description             = ""
  display_name            = "HDInsightKafkaLogs"
  name                    = "HDInsightKafkaLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-474" {
  description             = ""
  display_name            = "HDInsightKafkaMetrics"
  name                    = "HDInsightKafkaMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-475" {
  description             = ""
  display_name            = "HDInsightKafkaServerLog"
  name                    = "HDInsightKafkaServerLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-476" {
  description             = ""
  display_name            = "HDInsightOozieLogs"
  name                    = "HDInsightOozieLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-477" {
  description             = ""
  display_name            = "HDInsightRangerAuditLogs"
  name                    = "HDInsightRangerAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-478" {
  description             = ""
  display_name            = "HDInsightSecurityLogs"
  name                    = "HDInsightSecurityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-479" {
  description             = ""
  display_name            = "HDInsightSparkApplicationEvents"
  name                    = "HDInsightSparkApplicationEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-480" {
  description             = ""
  display_name            = "HDInsightSparkBlockManagerEvents"
  name                    = "HDInsightSparkBlockManagerEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-481" {
  description             = ""
  display_name            = "HDInsightSparkEnvironmentEvents"
  name                    = "HDInsightSparkEnvironmentEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-482" {
  description             = ""
  display_name            = "HDInsightSparkExecutorEvents"
  name                    = "HDInsightSparkExecutorEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-483" {
  description             = ""
  display_name            = "HDInsightSparkExtraEvents"
  name                    = "HDInsightSparkExtraEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-484" {
  description             = ""
  display_name            = "HDInsightSparkJobEvents"
  name                    = "HDInsightSparkJobEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-485" {
  description             = ""
  display_name            = "HDInsightSparkLogs"
  name                    = "HDInsightSparkLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-486" {
  description             = ""
  display_name            = "HDInsightSparkSQLExecutionEvents"
  name                    = "HDInsightSparkSQLExecutionEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-487" {
  description             = ""
  display_name            = "HDInsightSparkStageEvents"
  name                    = "HDInsightSparkStageEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-488" {
  description             = ""
  display_name            = "HDInsightSparkStageTaskAccumulables"
  name                    = "HDInsightSparkStageTaskAccumulables"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-489" {
  description             = ""
  display_name            = "HDInsightSparkTaskEvents"
  name                    = "HDInsightSparkTaskEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-490" {
  description             = ""
  display_name            = "HDInsightStormLogs"
  name                    = "HDInsightStormLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-491" {
  description             = ""
  display_name            = "HDInsightStormMetrics"
  name                    = "HDInsightStormMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-492" {
  description             = ""
  display_name            = "HDInsightStormTopologyMetrics"
  name                    = "HDInsightStormTopologyMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-493" {
  description             = ""
  display_name            = "HealthStateChangeEvent"
  name                    = "HealthStateChangeEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-494" {
  description             = ""
  display_name            = "Heartbeat"
  name                    = "Heartbeat"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-495" {
  description             = ""
  display_name            = "InsightsMetrics"
  name                    = "InsightsMetrics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-496" {
  description             = ""
  display_name            = "IntuneAuditLogs"
  name                    = "IntuneAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-497" {
  description             = ""
  display_name            = "IntuneDeviceComplianceOrg"
  name                    = "IntuneDeviceComplianceOrg"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-498" {
  description             = ""
  display_name            = "IntuneDevices"
  name                    = "IntuneDevices"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-499" {
  description             = ""
  display_name            = "IntuneOperationalLogs"
  name                    = "IntuneOperationalLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-500" {
  description             = ""
  display_name            = "KubeEvents"
  name                    = "KubeEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-501" {
  description             = ""
  display_name            = "KubeHealth"
  name                    = "KubeHealth"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-502" {
  description             = ""
  display_name            = "KubeMonAgentEvents"
  name                    = "KubeMonAgentEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-503" {
  description             = ""
  display_name            = "KubeNodeInventory"
  name                    = "KubeNodeInventory"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-504" {
  description             = ""
  display_name            = "KubePVInventory"
  name                    = "KubePVInventory"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-505" {
  description             = ""
  display_name            = "KubePodInventory"
  name                    = "KubePodInventory"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-506" {
  description             = ""
  display_name            = "KubeServices"
  name                    = "KubeServices"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-507" {
  description             = ""
  display_name            = "LAJobLogs"
  name                    = "LAJobLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-508" {
  description             = ""
  display_name            = "LAQueryLogs"
  name                    = "LAQueryLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-509" {
  description             = ""
  display_name            = "LASummaryLogs"
  name                    = "LASummaryLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-510" {
  description             = ""
  display_name            = "LIATrackingEvents"
  name                    = "LIATrackingEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-511" {
  description             = ""
  display_name            = "LedgerTransactionLogs"
  name                    = "LedgerTransactionLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-512" {
  description             = ""
  display_name            = "LedgerUserDefinedLogs"
  name                    = "LedgerUserDefinedLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-513" {
  description             = ""
  display_name            = "LogicAppWorkflowRuntime"
  name                    = "LogicAppWorkflowRuntime"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-514" {
  description             = ""
  display_name            = "MCCEventLogs"
  name                    = "MCCEventLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-515" {
  description             = ""
  display_name            = "MCVPAuditLogs"
  name                    = "MCVPAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-516" {
  description             = ""
  display_name            = "MCVPOperationLogs"
  name                    = "MCVPOperationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-517" {
  description             = ""
  display_name            = "MDCDetectionDNSEvents"
  name                    = "MDCDetectionDNSEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-518" {
  description             = ""
  display_name            = "MDCDetectionFimEvents"
  name                    = "MDCDetectionFimEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-519" {
  description             = ""
  display_name            = "MDCDetectionGatingValidationEvents"
  name                    = "MDCDetectionGatingValidationEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-520" {
  description             = ""
  display_name            = "MDCDetectionK8SApiEvents"
  name                    = "MDCDetectionK8SApiEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-521" {
  description             = ""
  display_name            = "MDCDetectionProcessV2Events"
  name                    = "MDCDetectionProcessV2Events"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-522" {
  description             = ""
  display_name            = "MDCFileIntegrityMonitoringEvents"
  name                    = "MDCFileIntegrityMonitoringEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-523" {
  description             = ""
  display_name            = "MDECustomCollectionDeviceFileEvents"
  name                    = "MDECustomCollectionDeviceFileEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-524" {
  description             = ""
  display_name            = "MDPResourceLog"
  name                    = "MDPResourceLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-525" {
  description             = ""
  display_name            = "MNFDeviceUpdates"
  name                    = "MNFDeviceUpdates"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-526" {
  description             = ""
  display_name            = "MNFSystemSessionHistoryUpdates"
  name                    = "MNFSystemSessionHistoryUpdates"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-527" {
  description             = ""
  display_name            = "MNFSystemStateMessageUpdates"
  name                    = "MNFSystemStateMessageUpdates"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-528" {
  description             = ""
  display_name            = "MPCAuditLogs"
  name                    = "MPCAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-529" {
  description             = ""
  display_name            = "MPCIngestionLogs"
  name                    = "MPCIngestionLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-530" {
  description             = ""
  display_name            = "MeshControlPlane"
  name                    = "MeshControlPlane"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-531" {
  description             = ""
  display_name            = "MicrosoftAzureBastionAuditLogs"
  name                    = "MicrosoftAzureBastionAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-532" {
  description             = ""
  display_name            = "MicrosoftDataShareReceivedSnapshotLog"
  name                    = "MicrosoftDataShareReceivedSnapshotLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-533" {
  description             = ""
  display_name            = "MicrosoftDataShareSentSnapshotLog"
  name                    = "MicrosoftDataShareSentSnapshotLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-534" {
  description             = ""
  display_name            = "MicrosoftDataShareShareLog"
  name                    = "MicrosoftDataShareShareLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-535" {
  description             = ""
  display_name            = "MicrosoftGraphActivityLogs"
  name                    = "MicrosoftGraphActivityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-536" {
  description             = ""
  display_name            = "MicrosoftGraphPolicyLogs"
  name                    = "MicrosoftGraphPolicyLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-537" {
  description             = ""
  display_name            = "MicrosoftHealthcareApisAuditLogs"
  name                    = "MicrosoftHealthcareApisAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-538" {
  description             = ""
  display_name            = "MicrosoftServicePrincipalSignInLogs"
  name                    = "MicrosoftServicePrincipalSignInLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-539" {
  description             = ""
  display_name            = "MySqlAuditLogs"
  name                    = "MySqlAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-540" {
  description             = ""
  display_name            = "MySqlSlowLogs"
  name                    = "MySqlSlowLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-541" {
  description             = ""
  display_name            = "NCBMBreakGlassAuditLogs"
  name                    = "NCBMBreakGlassAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-542" {
  description             = ""
  display_name            = "NCBMSecurityDefenderLogs"
  name                    = "NCBMSecurityDefenderLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-543" {
  description             = ""
  display_name            = "NCBMSecurityLogs"
  name                    = "NCBMSecurityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-544" {
  description             = ""
  display_name            = "NCBMSystemLogs"
  name                    = "NCBMSystemLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-545" {
  description             = ""
  display_name            = "NCCIDRACLogs"
  name                    = "NCCIDRACLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-546" {
  description             = ""
  display_name            = "NCCKubernetesAPIAuditLogs"
  name                    = "NCCKubernetesAPIAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-547" {
  description             = ""
  display_name            = "NCCKubernetesLogs"
  name                    = "NCCKubernetesLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-548" {
  description             = ""
  display_name            = "NCCPlatformOperationsLogs"
  name                    = "NCCPlatformOperationsLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-549" {
  description             = ""
  display_name            = "NCCVMOrchestrationLogs"
  name                    = "NCCVMOrchestrationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-550" {
  description             = ""
  display_name            = "NCMClusterOperationsLogs"
  name                    = "NCMClusterOperationsLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-551" {
  description             = ""
  display_name            = "NCSStorageAlerts"
  name                    = "NCSStorageAlerts"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-552" {
  description             = ""
  display_name            = "NCSStorageAudits"
  name                    = "NCSStorageAudits"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-553" {
  description             = ""
  display_name            = "NCSStorageLogs"
  name                    = "NCSStorageLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-554" {
  description             = ""
  display_name            = "NGXOperationLogs"
  name                    = "NGXOperationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-555" {
  description             = ""
  display_name            = "NGXSecurityLogs"
  name                    = "NGXSecurityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-556" {
  description             = ""
  display_name            = "NSPAccessLogs"
  name                    = "NSPAccessLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-557" {
  description             = ""
  display_name            = "NTAInsights"
  name                    = "NTAInsights"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-558" {
  description             = ""
  display_name            = "NTAIpDetails"
  name                    = "NTAIpDetails"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-559" {
  description             = ""
  display_name            = "NTANetAnalytics"
  name                    = "NTANetAnalytics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-560" {
  description             = ""
  display_name            = "NTANspRuleRecommendation"
  name                    = "NTANspRuleRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-561" {
  description             = ""
  display_name            = "NTARuleRecommendation"
  name                    = "NTARuleRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-562" {
  description             = ""
  display_name            = "NTATopologyDetails"
  name                    = "NTATopologyDetails"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-563" {
  description             = ""
  display_name            = "NWConnectionMonitorDNSResult"
  name                    = "NWConnectionMonitorDNSResult"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-564" {
  description             = ""
  display_name            = "NWConnectionMonitorDestinationListenerResult"
  name                    = "NWConnectionMonitorDestinationListenerResult"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-565" {
  description             = ""
  display_name            = "NWConnectionMonitorPathResult"
  name                    = "NWConnectionMonitorPathResult"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-566" {
  description             = ""
  display_name            = "NWConnectionMonitorTestResult"
  name                    = "NWConnectionMonitorTestResult"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-567" {
  description             = ""
  display_name            = "NatGatewayFlowlogsV1"
  name                    = "NatGatewayFlowlogsV1"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-568" {
  description             = ""
  display_name            = "NetworkAccessAlerts"
  name                    = "NetworkAccessAlerts"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-569" {
  description             = ""
  display_name            = "NetworkAccessConnectionEvents"
  name                    = "NetworkAccessConnectionEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-570" {
  description             = ""
  display_name            = "NetworkAccessGenerativeAIInsights"
  name                    = "NetworkAccessGenerativeAIInsights"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-571" {
  description             = ""
  display_name            = "NetworkAccessTraffic"
  name                    = "NetworkAccessTraffic"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-572" {
  description             = ""
  display_name            = "NginxUpstreamUpdateLogs"
  name                    = "NginxUpstreamUpdateLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-573" {
  description             = ""
  display_name            = "OEPAirFlowTask"
  name                    = "OEPAirFlowTask"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-574" {
  description             = ""
  display_name            = "OEPAuditLogs"
  name                    = "OEPAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-575" {
  description             = ""
  display_name            = "OEPDataplaneLogs"
  name                    = "OEPDataplaneLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-576" {
  description             = ""
  display_name            = "OEPElasticOperator"
  name                    = "OEPElasticOperator"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-577" {
  description             = ""
  display_name            = "OEPElasticsearch"
  name                    = "OEPElasticsearch"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-578" {
  description             = ""
  display_name            = "OEWAuditLogs"
  name                    = "OEWAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-579" {
  description             = ""
  display_name            = "OEWExperimentAssignmentSummary"
  name                    = "OEWExperimentAssignmentSummary"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-580" {
  description             = ""
  display_name            = "OEWExperimentScorecardMetricPairs"
  name                    = "OEWExperimentScorecardMetricPairs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-581" {
  description             = ""
  display_name            = "OEWExperimentScorecards"
  name                    = "OEWExperimentScorecards"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-582" {
  description             = ""
  display_name            = "OGOAuditLogs"
  name                    = "OGOAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-583" {
  description             = ""
  display_name            = "OLPSupplyChainEntityOperations"
  name                    = "OLPSupplyChainEntityOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-584" {
  description             = ""
  display_name            = "OLPSupplyChainEvents"
  name                    = "OLPSupplyChainEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-585" {
  description             = ""
  display_name            = "OTelEvents"
  name                    = "OTelEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-586" {
  description             = ""
  display_name            = "OTelLogs"
  name                    = "OTelLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-587" {
  description             = ""
  display_name            = "OTelResources"
  name                    = "OTelResources"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-588" {
  description             = ""
  display_name            = "OTelSpans"
  name                    = "OTelSpans"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-589" {
  description             = ""
  display_name            = "OTelTraces"
  name                    = "OTelTraces"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-590" {
  description             = ""
  display_name            = "OTelTracesAgent"
  name                    = "OTelTracesAgent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-591" {
  description             = ""
  display_name            = "Operation"
  name                    = "Operation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-592" {
  description             = ""
  display_name            = "OracleCloudDatabase"
  name                    = "OracleCloudDatabase"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-593" {
  description             = ""
  display_name            = "PFTitleAuditLogs"
  name                    = "PFTitleAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-594" {
  description             = ""
  display_name            = "PGSQLAutovacuumStats"
  name                    = "PGSQLAutovacuumStats"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-595" {
  description             = ""
  display_name            = "PGSQLDbTransactionsStats"
  name                    = "PGSQLDbTransactionsStats"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-596" {
  description             = ""
  display_name            = "PGSQLPgBouncer"
  name                    = "PGSQLPgBouncer"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-597" {
  description             = ""
  display_name            = "PGSQLPgStatActivitySessions"
  name                    = "PGSQLPgStatActivitySessions"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-598" {
  description             = ""
  display_name            = "PGSQLQueryStoreQueryText"
  name                    = "PGSQLQueryStoreQueryText"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-599" {
  description             = ""
  display_name            = "PGSQLQueryStoreRuntime"
  name                    = "PGSQLQueryStoreRuntime"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-600" {
  description             = ""
  display_name            = "PGSQLQueryStoreWaits"
  name                    = "PGSQLQueryStoreWaits"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-601" {
  description             = ""
  display_name            = "PGSQLServerLogs"
  name                    = "PGSQLServerLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-602" {
  description             = ""
  display_name            = "Perf"
  name                    = "Perf"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-603" {
  description             = ""
  display_name            = "PerfInsightsFindings"
  name                    = "PerfInsightsFindings"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-604" {
  description             = ""
  display_name            = "PerfInsightsImpactedResources"
  name                    = "PerfInsightsImpactedResources"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-605" {
  description             = ""
  display_name            = "PerfInsightsRun"
  name                    = "PerfInsightsRun"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-606" {
  description             = ""
  display_name            = "PowerBIDatasetsTenant"
  name                    = "PowerBIDatasetsTenant"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-607" {
  description             = ""
  display_name            = "PowerBIDatasetsWorkspace"
  name                    = "PowerBIDatasetsWorkspace"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-608" {
  description             = ""
  display_name            = "PreAuthenticationDiscoveryLogs"
  name                    = "PreAuthenticationDiscoveryLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-609" {
  description             = ""
  display_name            = "PurviewDataSensitivityLogs"
  name                    = "PurviewDataSensitivityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-610" {
  description             = ""
  display_name            = "PurviewScanStatusLogs"
  name                    = "PurviewScanStatusLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-611" {
  description             = ""
  display_name            = "PurviewSecurityLogs"
  name                    = "PurviewSecurityLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-612" {
  description             = ""
  display_name            = "QuantumProviderAccountDeviceOperationLogs"
  name                    = "QuantumProviderAccountDeviceOperationLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-613" {
  description             = ""
  display_name            = "QuantumProviderAccountJobAuditLogs"
  name                    = "QuantumProviderAccountJobAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-614" {
  description             = ""
  display_name            = "QuantumProviderAccountQueueAuditLogs"
  name                    = "QuantumProviderAccountQueueAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-615" {
  description             = ""
  display_name            = "QuantumProviderAccountTargetAuditLogs"
  name                    = "QuantumProviderAccountTargetAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-616" {
  description             = ""
  display_name            = "QuantumWorkspaceJobAuditLogs"
  name                    = "QuantumWorkspaceJobAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-617" {
  description             = ""
  display_name            = "REDConnectionEvents"
  name                    = "REDConnectionEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-618" {
  description             = ""
  display_name            = "RemoteNetworkHealthLogs"
  name                    = "RemoteNetworkHealthLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-619" {
  description             = ""
  display_name            = "ResourceManagementPublicAccessLogs"
  name                    = "ResourceManagementPublicAccessLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-620" {
  description             = ""
  display_name            = "RetinaNetworkFlowLogs"
  name                    = "RetinaNetworkFlowLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-621" {
  description             = ""
  display_name            = "SCCMAssessmentRecommendation"
  name                    = "SCCMAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-622" {
  description             = ""
  display_name            = "SCGPoolExecutionLog"
  name                    = "SCGPoolExecutionLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-623" {
  description             = ""
  display_name            = "SCGPoolRequestLog"
  name                    = "SCGPoolRequestLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-624" {
  description             = ""
  display_name            = "SCOMAssessmentRecommendation"
  name                    = "SCOMAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-625" {
  description             = ""
  display_name            = "SPAssessmentRecommendation"
  name                    = "SPAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-626" {
  description             = ""
  display_name            = "SQLAssessmentRecommendation"
  name                    = "SQLAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-627" {
  description             = ""
  display_name            = "SQLSecurityAuditEvents"
  name                    = "SQLSecurityAuditEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-628" {
  description             = ""
  display_name            = "SVMPoolExecutionLog"
  name                    = "SVMPoolExecutionLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-629" {
  description             = ""
  display_name            = "SVMPoolRequestLog"
  name                    = "SVMPoolRequestLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-630" {
  description             = ""
  display_name            = "SecurityCaseEvent"
  name                    = "SecurityCaseEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-631" {
  description             = ""
  display_name            = "ServiceFabricOperationalEvent"
  name                    = "ServiceFabricOperationalEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-632" {
  description             = ""
  display_name            = "ServiceFabricReliableActorEvent"
  name                    = "ServiceFabricReliableActorEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-633" {
  description             = ""
  display_name            = "ServiceFabricReliableServiceEvent"
  name                    = "ServiceFabricReliableServiceEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-634" {
  description             = ""
  display_name            = "SfBAssessmentRecommendation"
  name                    = "SfBAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-635" {
  description             = ""
  display_name            = "SfBOnlineAssessmentRecommendation"
  name                    = "SfBOnlineAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-636" {
  description             = ""
  display_name            = "SharePointOnlineAssessmentRecommendation"
  name                    = "SharePointOnlineAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-637" {
  description             = ""
  display_name            = "SignalRServiceDiagnosticLogs"
  name                    = "SignalRServiceDiagnosticLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-638" {
  description             = ""
  display_name            = "SigninLogs"
  name                    = "SigninLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-639" {
  description             = ""
  display_name            = "StorageAntimalwareScanResults"
  name                    = "StorageAntimalwareScanResults"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-640" {
  description             = ""
  display_name            = "StorageBlobLogs"
  name                    = "StorageBlobLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-641" {
  description             = ""
  display_name            = "StorageCacheOperationEvents"
  name                    = "StorageCacheOperationEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-642" {
  description             = ""
  display_name            = "StorageCacheUpgradeEvents"
  name                    = "StorageCacheUpgradeEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-643" {
  description             = ""
  display_name            = "StorageCacheWarningEvents"
  name                    = "StorageCacheWarningEvents"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-644" {
  description             = ""
  display_name            = "StorageFileLogs"
  name                    = "StorageFileLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-645" {
  description             = ""
  display_name            = "StorageMalwareScanningResults"
  name                    = "StorageMalwareScanningResults"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-646" {
  description             = ""
  display_name            = "StorageMoverAuditLogs"
  name                    = "StorageMoverAuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-647" {
  description             = ""
  display_name            = "StorageMoverCopyLogsFailed"
  name                    = "StorageMoverCopyLogsFailed"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-648" {
  description             = ""
  display_name            = "StorageMoverCopyLogsTransferred"
  name                    = "StorageMoverCopyLogsTransferred"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-649" {
  description             = ""
  display_name            = "StorageMoverJobRunLogs"
  name                    = "StorageMoverJobRunLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-650" {
  description             = ""
  display_name            = "StorageQueueLogs"
  name                    = "StorageQueueLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-651" {
  description             = ""
  display_name            = "StorageTableLogs"
  name                    = "StorageTableLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-652" {
  description             = ""
  display_name            = "SucceededIngestion"
  name                    = "SucceededIngestion"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-653" {
  description             = ""
  display_name            = "SynapseBigDataPoolApplicationsEnded"
  name                    = "SynapseBigDataPoolApplicationsEnded"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-654" {
  description             = ""
  display_name            = "SynapseBuiltinSqlPoolRequestsEnded"
  name                    = "SynapseBuiltinSqlPoolRequestsEnded"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-655" {
  description             = ""
  display_name            = "SynapseDXCommand"
  name                    = "SynapseDXCommand"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-656" {
  description             = ""
  display_name            = "SynapseDXFailedIngestion"
  name                    = "SynapseDXFailedIngestion"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-657" {
  description             = ""
  display_name            = "SynapseDXIngestionBatching"
  name                    = "SynapseDXIngestionBatching"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-658" {
  description             = ""
  display_name            = "SynapseDXQuery"
  name                    = "SynapseDXQuery"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-659" {
  description             = ""
  display_name            = "SynapseDXSucceededIngestion"
  name                    = "SynapseDXSucceededIngestion"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-660" {
  description             = ""
  display_name            = "SynapseDXTableDetails"
  name                    = "SynapseDXTableDetails"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-661" {
  description             = ""
  display_name            = "SynapseDXTableUsageStatistics"
  name                    = "SynapseDXTableUsageStatistics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-662" {
  description             = ""
  display_name            = "SynapseGatewayApiRequests"
  name                    = "SynapseGatewayApiRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-663" {
  description             = ""
  display_name            = "SynapseIntegrationActivityRuns"
  name                    = "SynapseIntegrationActivityRuns"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-664" {
  description             = ""
  display_name            = "SynapseIntegrationPipelineRuns"
  name                    = "SynapseIntegrationPipelineRuns"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-665" {
  description             = ""
  display_name            = "SynapseIntegrationTriggerRuns"
  name                    = "SynapseIntegrationTriggerRuns"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-666" {
  description             = ""
  display_name            = "SynapseLinkEvent"
  name                    = "SynapseLinkEvent"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-667" {
  description             = ""
  display_name            = "SynapseRbacOperations"
  name                    = "SynapseRbacOperations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-668" {
  description             = ""
  display_name            = "SynapseScopePoolScopeJobsEnded"
  name                    = "SynapseScopePoolScopeJobsEnded"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-669" {
  description             = ""
  display_name            = "SynapseScopePoolScopeJobsStateChange"
  name                    = "SynapseScopePoolScopeJobsStateChange"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-670" {
  description             = ""
  display_name            = "SynapseSqlPoolDmsWorkers"
  name                    = "SynapseSqlPoolDmsWorkers"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-671" {
  description             = ""
  display_name            = "SynapseSqlPoolExecRequests"
  name                    = "SynapseSqlPoolExecRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-672" {
  description             = ""
  display_name            = "SynapseSqlPoolRequestSteps"
  name                    = "SynapseSqlPoolRequestSteps"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-673" {
  description             = ""
  display_name            = "SynapseSqlPoolSqlRequests"
  name                    = "SynapseSqlPoolSqlRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-674" {
  description             = ""
  display_name            = "SynapseSqlPoolWaits"
  name                    = "SynapseSqlPoolWaits"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-675" {
  description             = ""
  display_name            = "Syslog"
  name                    = "Syslog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-676" {
  description             = ""
  display_name            = "TOUserAudits"
  name                    = "TOUserAudits"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-677" {
  description             = ""
  display_name            = "TOUserDiagnostics"
  name                    = "TOUserDiagnostics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-678" {
  description             = ""
  display_name            = "TSIIngress"
  name                    = "TSIIngress"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-679" {
  description             = ""
  display_name            = "UCClient"
  name                    = "UCClient"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-680" {
  description             = ""
  display_name            = "UCClientReadinessStatus"
  name                    = "UCClientReadinessStatus"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-681" {
  description             = ""
  display_name            = "UCClientUpdateStatus"
  name                    = "UCClientUpdateStatus"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-682" {
  description             = ""
  display_name            = "UCDOAggregatedStatus"
  name                    = "UCDOAggregatedStatus"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-683" {
  description             = ""
  display_name            = "UCDOStatus"
  name                    = "UCDOStatus"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-684" {
  description             = ""
  display_name            = "UCDeviceAlert"
  name                    = "UCDeviceAlert"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-685" {
  description             = ""
  display_name            = "UCServiceUpdateStatus"
  name                    = "UCServiceUpdateStatus"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-686" {
  description             = ""
  display_name            = "UCUpdateAlert"
  name                    = "UCUpdateAlert"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-687" {
  description             = ""
  display_name            = "Usage"
  name                    = "Usage"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-688" {
  description             = ""
  display_name            = "VCoreMongoRequests"
  name                    = "VCoreMongoRequests"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-689" {
  description             = ""
  display_name            = "VIAudit"
  name                    = "VIAudit"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-690" {
  description             = ""
  display_name            = "VIIndexing"
  name                    = "VIIndexing"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-691" {
  description             = ""
  display_name            = "VMBoundPort"
  name                    = "VMBoundPort"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-692" {
  description             = ""
  display_name            = "VMComputer"
  name                    = "VMComputer"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-693" {
  description             = ""
  display_name            = "VMConnection"
  name                    = "VMConnection"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-694" {
  description             = ""
  display_name            = "VMProcess"
  name                    = "VMProcess"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-695" {
  description             = ""
  display_name            = "W3CIISLog"
  name                    = "W3CIISLog"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-696" {
  description             = ""
  display_name            = "WOUserAudits"
  name                    = "WOUserAudits"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-697" {
  description             = ""
  display_name            = "WOUserDiagnostics"
  name                    = "WOUserDiagnostics"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-698" {
  description             = ""
  display_name            = "WVDAgentHealthStatus"
  name                    = "WVDAgentHealthStatus"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-699" {
  description             = ""
  display_name            = "WVDAutoscaleEvaluationPooled"
  name                    = "WVDAutoscaleEvaluationPooled"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-700" {
  description             = ""
  display_name            = "WVDCheckpoints"
  name                    = "WVDCheckpoints"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-701" {
  description             = ""
  display_name            = "WVDConnectionGraphicsDataPreview"
  name                    = "WVDConnectionGraphicsDataPreview"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-702" {
  description             = ""
  display_name            = "WVDConnectionNetworkData"
  name                    = "WVDConnectionNetworkData"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-703" {
  description             = ""
  display_name            = "WVDConnections"
  name                    = "WVDConnections"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-704" {
  description             = ""
  display_name            = "WVDErrors"
  name                    = "WVDErrors"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-705" {
  description             = ""
  display_name            = "WVDFeeds"
  name                    = "WVDFeeds"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-706" {
  description             = ""
  display_name            = "WVDHostRegistrations"
  name                    = "WVDHostRegistrations"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-707" {
  description             = ""
  display_name            = "WVDManagement"
  name                    = "WVDManagement"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-708" {
  description             = ""
  display_name            = "WVDMultiLinkAdd"
  name                    = "WVDMultiLinkAdd"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-709" {
  description             = ""
  display_name            = "WVDSessionHostManagement"
  name                    = "WVDSessionHostManagement"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-710" {
  description             = ""
  display_name            = "WebPubSubConnectivity"
  name                    = "WebPubSubConnectivity"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-711" {
  description             = ""
  display_name            = "WebPubSubHttpRequest"
  name                    = "WebPubSubHttpRequest"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-712" {
  description             = ""
  display_name            = "WebPubSubMessaging"
  name                    = "WebPubSubMessaging"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-713" {
  description             = ""
  display_name            = "Windows365AuditLogs"
  name                    = "Windows365AuditLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-714" {
  description             = ""
  display_name            = "Windows365CheckpointLogs"
  name                    = "Windows365CheckpointLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-715" {
  description             = ""
  display_name            = "Windows365ConnectionErrorLogs"
  name                    = "Windows365ConnectionErrorLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-716" {
  description             = ""
  display_name            = "Windows365ConnectionLogs"
  name                    = "Windows365ConnectionLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-717" {
  description             = ""
  display_name            = "Windows365NetworkLogs"
  name                    = "Windows365NetworkLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-718" {
  description             = ""
  display_name            = "WindowsClientAssessmentRecommendation"
  name                    = "WindowsClientAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-719" {
  description             = ""
  display_name            = "WindowsServerAssessmentRecommendation"
  name                    = "WindowsServerAssessmentRecommendation"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-720" {
  description             = ""
  display_name            = "WorkloadDiagnosticLogs"
  name                    = "WorkloadDiagnosticLogs"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-721" {
  description             = ""
  display_name            = "ZTSGraph"
  name                    = "ZTSGraph"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-722" {
  description             = ""
  display_name            = "ZTSJobStatus"
  name                    = "ZTSJobStatus"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-723" {
  description             = ""
  display_name            = "ZTSMetadata"
  name                    = "ZTSMetadata"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}
resource "azurerm_log_analytics_workspace_table_custom_log" "res-724" {
  description             = ""
  display_name            = "ZTSRequest"
  name                    = "ZTSRequest"
  plan                    = "Analytics"
  retention_in_days       = 0
  total_retention_in_days = 0
  workspace_id            = azurerm_log_analytics_workspace.res-2.id
}


import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63"
  to = azurerm_resource_group.res-0
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.Insights/dataCollectionRules/dcrnabr7xkd"
  to = azurerm_monitor_data_collection_rule.res-1
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et"
  to = azurerm_log_analytics_workspace.res-2
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_General|AlphabeticallySortedComputers"
  to = azurerm_log_analytics_saved_search.res-3
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_General|StaleComputers"
  to = azurerm_log_analytics_saved_search.res-4
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_General|dataPointsPerManagementGroup"
  to = azurerm_log_analytics_saved_search.res-5
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_General|dataTypeDistribution"
  to = azurerm_log_analytics_saved_search.res-6
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|AllEvents"
  to = azurerm_log_analytics_saved_search.res-7
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|AllSyslog"
  to = azurerm_log_analytics_saved_search.res-8
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|AllSyslogByFacility"
  to = azurerm_log_analytics_saved_search.res-9
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|AllSyslogByProcessName"
  to = azurerm_log_analytics_saved_search.res-10
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|AllSyslogsWithErrors"
  to = azurerm_log_analytics_saved_search.res-11
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-12
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  to = azurerm_log_analytics_saved_search.res-13
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|CountIISLogEntriesClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-14
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  to = azurerm_log_analytics_saved_search.res-15
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  to = azurerm_log_analytics_saved_search.res-16
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  to = azurerm_log_analytics_saved_search.res-17
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|CountOfIISLogEntriesByURLForHost"
  to = azurerm_log_analytics_saved_search.res-18
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  to = azurerm_log_analytics_saved_search.res-19
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|CountOfWarningEvents"
  to = azurerm_log_analytics_saved_search.res-20
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|DisplayBreakdownRespondCodes"
  to = azurerm_log_analytics_saved_search.res-21
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|EventsByEventLog"
  to = azurerm_log_analytics_saved_search.res-22
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|EventsByEventSource"
  to = azurerm_log_analytics_saved_search.res-23
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|EventsByEventsID"
  to = azurerm_log_analytics_saved_search.res-24
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|EventsInOMBetween2000to3000"
  to = azurerm_log_analytics_saved_search.res-25
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|EventsWithStartedinEventID"
  to = azurerm_log_analytics_saved_search.res-26
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|FindMaximumTimeTakenForEachPage"
  to = azurerm_log_analytics_saved_search.res-27
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|IISLogEntriesForClientIP"
  to = azurerm_log_analytics_saved_search.res-28
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|ListAllIISLogEntries"
  to = azurerm_log_analytics_saved_search.res-29
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|NoOfConnectionsToOMSDKService"
  to = azurerm_log_analytics_saved_search.res-30
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|ServerRestartTime"
  to = azurerm_log_analytics_saved_search.res-31
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|Show404PagesList"
  to = azurerm_log_analytics_saved_search.res-32
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|ShowServersThrowingInternalServerError"
  to = azurerm_log_analytics_saved_search.res-33
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  to = azurerm_log_analytics_saved_search.res-34
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|TotalBytesReceivedByEachIISComputer"
  to = azurerm_log_analytics_saved_search.res-35
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-36
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  to = azurerm_log_analytics_saved_search.res-37
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|TotalBytesSentByClientIPAddress"
  to = azurerm_log_analytics_saved_search.res-38
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|WarningEvents"
  to = azurerm_log_analytics_saved_search.res-39
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|WindowsFireawallPolicySettingsChanged"
  to = azurerm_log_analytics_saved_search.res-40
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/savedSearches/LogManagement(laws1-sf5et)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  to = azurerm_log_analytics_saved_search.res-41
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AACAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-42
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AACHttpRequest"
  to = azurerm_log_analytics_workspace_table_custom_log.res-43
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADAgentRiskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-44
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADB2CRequestLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-45
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADCustomSecurityAttributeAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-46
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesAccountLogon"
  to = azurerm_log_analytics_workspace_table_custom_log.res-47
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesAccountManagement"
  to = azurerm_log_analytics_workspace_table_custom_log.res-48
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesDNSAuditsDynamicUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-49
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesDNSAuditsGeneral"
  to = azurerm_log_analytics_workspace_table_custom_log.res-50
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesDirectoryServiceAccess"
  to = azurerm_log_analytics_workspace_table_custom_log.res-51
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesLogonLogoff"
  to = azurerm_log_analytics_workspace_table_custom_log.res-52
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesPolicyChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-53
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesPrivilegeUse"
  to = azurerm_log_analytics_workspace_table_custom_log.res-54
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADDomainServicesSystemSecurity"
  to = azurerm_log_analytics_workspace_table_custom_log.res-55
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADFirstPartyToFirstPartySignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-56
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADGraphActivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-57
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADManagedIdentitySignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-58
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADNonInteractiveUserSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-59
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADProvisioningLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-60
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADRiskyAgents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-61
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADRiskyServicePrincipals"
  to = azurerm_log_analytics_workspace_table_custom_log.res-62
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADRiskyUsers"
  to = azurerm_log_analytics_workspace_table_custom_log.res-63
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADServicePrincipalRiskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-64
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADServicePrincipalSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-65
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AADUserRiskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-66
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ABSBotRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-67
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACICollaborationAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-68
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACLTransactionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-69
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACLUserDefinedLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-70
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACRConnectedClientList"
  to = azurerm_log_analytics_workspace_table_custom_log.res-71
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACREntraAuthenticationAuditLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-72
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSAdvancedMessagingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-73
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSAuthIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-74
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSBillingUsage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-75
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallAutomationIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-76
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallAutomationMediaSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-77
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallAutomationStreamingUsage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-78
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallClientMediaStatsTimeSeries"
  to = azurerm_log_analytics_workspace_table_custom_log.res-79
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallClientOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-80
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallClientServiceRequestAndOutcome"
  to = azurerm_log_analytics_workspace_table_custom_log.res-81
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallClosedCaptionsSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-82
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-83
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallDiagnosticsUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-84
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallRecordingIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-85
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallRecordingSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-86
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-87
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallSummaryUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-88
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallSurvey"
  to = azurerm_log_analytics_workspace_table_custom_log.res-89
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSCallingMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-90
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSChatIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-91
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSEmailSendMailOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-92
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSEmailStatusUpdateOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-93
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSEmailUserEngagementOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-94
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSJobRouterIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-95
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSOptOutManagementOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-96
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSRoomsIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-97
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ACSSMSIncomingOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-98
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-99
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFActivityRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-100
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFAirflowSchedulerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-101
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFAirflowTaskLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-102
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFAirflowWebLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-103
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFAirflowWorkerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-104
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFPipelineRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-105
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSSISIntegrationRuntimeLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-106
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSSISPackageEventMessageContext"
  to = azurerm_log_analytics_workspace_table_custom_log.res-107
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSSISPackageEventMessages"
  to = azurerm_log_analytics_workspace_table_custom_log.res-108
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSSISPackageExecutableStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-109
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSSISPackageExecutionComponentPhases"
  to = azurerm_log_analytics_workspace_table_custom_log.res-110
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSSISPackageExecutionDataStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-111
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-112
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSandboxActivityRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-113
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFSandboxPipelineRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-114
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADFTriggerRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-115
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADGSyslogEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-116
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADReplicationResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-117
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADSecurityAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-118
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADTDataHistoryOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-119
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADTDigitalTwinsOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-120
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADTEventRoutesOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-121
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADTModelsOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-122
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADTQueryOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-123
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADXCommand"
  to = azurerm_log_analytics_workspace_table_custom_log.res-124
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADXDataOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-125
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADXIngestionBatching"
  to = azurerm_log_analytics_workspace_table_custom_log.res-126
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADXJournal"
  to = azurerm_log_analytics_workspace_table_custom_log.res-127
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADXQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-128
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADXTableDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-129
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ADXTableUsageStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-130
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AEWAssignmentBlobLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-131
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AEWAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-132
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AEWComputePipelinesLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-133
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AEWExperimentAssignmentSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-134
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AEWExperimentScorecardMetricPairs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-135
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AEWExperimentScorecards"
  to = azurerm_log_analytics_workspace_table_custom_log.res-136
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AFSAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-137
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGCAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-138
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGCFirewallLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-139
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGSGrafanaAlertAuthFailure"
  to = azurerm_log_analytics_workspace_table_custom_log.res-140
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGSGrafanaLoginEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-141
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGSGrafanaUsageInsightsEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-142
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGSUpdateEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-143
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGWAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-144
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGWFirewallLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-145
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AGWPerformanceLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-146
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AHCIDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-147
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AHDSDeidAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-148
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AHDSDicomAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-149
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AHDSDicomDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-150
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AHDSMedTechDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-151
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AKSAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-152
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AKSAuditAdmin"
  to = azurerm_log_analytics_workspace_table_custom_log.res-153
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AKSControlPlane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-154
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ALBHealthEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-155
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AMAHealth"
  to = azurerm_log_analytics_workspace_table_custom_log.res-156
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AMSKeyDeliveryRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-157
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AMSLiveEventOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-158
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AMSMediaAccountHealth"
  to = azurerm_log_analytics_workspace_table_custom_log.res-159
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AMSStreamingEndpointRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-160
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AMWMetricsUsageDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-161
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ANFFileAccess"
  to = azurerm_log_analytics_workspace_table_custom_log.res-162
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ANFTopClientReadIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-163
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ANFTopClientWriteIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-164
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ANFTopFileReadIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-165
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ANFTopFileWriteIOPS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-166
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AOIDatabaseQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-167
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AOIDigestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-168
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AOIStorage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-169
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/APIMDevPortalAuditDiagnosticLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-170
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASCAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-171
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASCDeviceEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-172
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRJobs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-173
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRReplicatedItems"
  to = azurerm_log_analytics_workspace_table_custom_log.res-174
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRv2HealthEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-175
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRv2JobEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-176
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRv2ProtectedItems"
  to = azurerm_log_analytics_workspace_table_custom_log.res-177
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRv2ReplicationExtensions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-178
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRv2ReplicationPolicies"
  to = azurerm_log_analytics_workspace_table_custom_log.res-179
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ASRv2ReplicationVaults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-180
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ATCExpressRouteCircuitIpfix"
  to = azurerm_log_analytics_workspace_table_custom_log.res-181
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ATCMicrosoftPeeringMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-182
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ATCPrivatePeeringMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-183
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVNMConnectivityConfigurationChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-184
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVNMIPAMPoolAllocationChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-185
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVNMNetworkGroupMembershipChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-186
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVNMRuleCollectionChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-187
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVSEsxiFirewallSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-188
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVSEsxiSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-189
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVSNsxEdgeSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-190
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVSNsxManagerSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-191
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVSSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-192
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AVSVcSyslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-193
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWApplicationRule"
  to = azurerm_log_analytics_workspace_table_custom_log.res-194
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWApplicationRuleAggregation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-195
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWDnsFlowTrace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-196
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWDnsQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-197
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWFatFlow"
  to = azurerm_log_analytics_workspace_table_custom_log.res-198
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWFlowTrace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-199
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWIdpsSignature"
  to = azurerm_log_analytics_workspace_table_custom_log.res-200
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWInternalFqdnResolutionFailure"
  to = azurerm_log_analytics_workspace_table_custom_log.res-201
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWNatRule"
  to = azurerm_log_analytics_workspace_table_custom_log.res-202
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWNatRuleAggregation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-203
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWNetworkRule"
  to = azurerm_log_analytics_workspace_table_custom_log.res-204
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWNetworkRuleAggregation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-205
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZFWThreatIntel"
  to = azurerm_log_analytics_workspace_table_custom_log.res-206
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZKVAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-207
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZKVPolicyEvaluationDetailsLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-208
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSApplicationMetricLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-209
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSArchiveLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-210
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSAutoscaleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-211
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSCustomerManagedKeyUserLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-212
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSDiagnosticErrorLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-213
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSHybridConnectionsEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-214
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSKafkaCoordinatorLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-215
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSKafkaUserErrorLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-216
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSOperationalLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-217
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSRunTimeAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-218
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AZMSVnetConnectionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-219
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AddonAzureBackupAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-220
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AddonAzureBackupJobs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-221
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AddonAzureBackupPolicy"
  to = azurerm_log_analytics_workspace_table_custom_log.res-222
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AddonAzureBackupProtectedInstance"
  to = azurerm_log_analytics_workspace_table_custom_log.res-223
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AddonAzureBackupStorage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-224
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AegDataPlaneRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-225
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AegDeliveryFailureLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-226
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AegPublishFailureLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-227
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodApplicationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-228
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodFarmManagementLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-229
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodFarmOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-230
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodInsightLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-231
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodJobProcessedLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-232
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodModelInferenceLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-233
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodProviderAuthLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-234
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodSatelliteLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-235
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodSensorManagementLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-236
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AgriFoodWeatherLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-237
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AirflowDagProcessingLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-238
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Alert"
  to = azurerm_log_analytics_workspace_table_custom_log.res-239
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlComputeClusterEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-240
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlComputeClusterNodeEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-241
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlComputeCpuGpuUtilization"
  to = azurerm_log_analytics_workspace_table_custom_log.res-242
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlComputeInstanceEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-243
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlComputeJobEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-244
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlDataLabelEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-245
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlDataSetEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-246
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlDataStoreEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-247
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlDeploymentEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-248
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlEnvironmentEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-249
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlInferencingEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-250
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlModelsEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-251
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlOnlineEndpointConsoleLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-252
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlOnlineEndpointEventLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-253
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlOnlineEndpointTrafficLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-254
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlPipelineEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-255
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlRegistryReadEventsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-256
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlRegistryWriteEventsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-257
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlRunEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-258
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AmlRunStatusChangedEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-259
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ApiManagementGatewayLlmLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-260
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ApiManagementGatewayLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-261
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ApiManagementGatewayMCPLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-262
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ApiManagementWebSocketConnectionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-263
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppAvailabilityResults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-264
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppBrowserTimings"
  to = azurerm_log_analytics_workspace_table_custom_log.res-265
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppCenterError"
  to = azurerm_log_analytics_workspace_table_custom_log.res-266
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppDependencies"
  to = azurerm_log_analytics_workspace_table_custom_log.res-267
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppEnvSessionConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-268
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppEnvSessionLifecycleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-269
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppEnvSessionPoolEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-270
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppEnvSpringAppConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-271
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-272
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppExceptions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-273
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppGenAIContent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-274
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-275
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppPageViews"
  to = azurerm_log_analytics_workspace_table_custom_log.res-276
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppPerformanceCounters"
  to = azurerm_log_analytics_workspace_table_custom_log.res-277
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppPlatformBuildLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-278
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppPlatformContainerEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-279
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppPlatformIngressLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-280
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppPlatformLogsforSpring"
  to = azurerm_log_analytics_workspace_table_custom_log.res-281
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppPlatformSystemLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-282
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-283
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceAntivirusScanAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-284
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceAppLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-285
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-286
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceAuthenticationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-287
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-288
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceEnvironmentPlatformLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-289
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceFileAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-290
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceHTTPLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-291
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceIPSecAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-292
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServicePlatformLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-293
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppServiceServerlessSecurityPluginData"
  to = azurerm_log_analytics_workspace_table_custom_log.res-294
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppSystemEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-295
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AppTraces"
  to = azurerm_log_analytics_workspace_table_custom_log.res-296
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ArcK8sAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-297
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ArcK8sAuditAdmin"
  to = azurerm_log_analytics_workspace_table_custom_log.res-298
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ArcK8sControlPlane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-299
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-300
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AutoscaleEvaluationsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-301
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AutoscaleScaleActionsLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-302
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureActivity"
  to = azurerm_log_analytics_workspace_table_custom_log.res-303
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureActivityV2"
  to = azurerm_log_analytics_workspace_table_custom_log.res-304
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-305
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureAttestationDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-306
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureBackupOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-307
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureDevOpsAuditing"
  to = azurerm_log_analytics_workspace_table_custom_log.res-308
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureLoadTestingOperation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-309
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-310
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureMetricsV2"
  to = azurerm_log_analytics_workspace_table_custom_log.res-311
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureMonitorPipelineLogErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-312
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLAutomaticTuning"
  to = azurerm_log_analytics_workspace_table_custom_log.res-313
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLBlocks"
  to = azurerm_log_analytics_workspace_table_custom_log.res-314
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLDatabaseWaitStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-315
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLDeadlocks"
  to = azurerm_log_analytics_workspace_table_custom_log.res-316
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-317
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLQueryStoreRuntimeStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-318
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLQueryStoreWaitStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-319
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLResourceUsageStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-320
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/AzureSQLTimeouts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-321
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/BehaviorEntities"
  to = azurerm_log_analytics_workspace_table_custom_log.res-322
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/BehaviorInfo"
  to = azurerm_log_analytics_workspace_table_custom_log.res-323
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/BlockchainApplicationLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-324
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/BlockchainProxyLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-325
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CCFApplicationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-326
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBCassandraRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-327
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBControlPlaneRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-328
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBDataPlaneRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-329
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBDataPlaneRequests15M"
  to = azurerm_log_analytics_workspace_table_custom_log.res-330
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBDataPlaneRequests5M"
  to = azurerm_log_analytics_workspace_table_custom_log.res-331
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBGremlinRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-332
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBMongoRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-333
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBPartitionKeyRUConsumption"
  to = azurerm_log_analytics_workspace_table_custom_log.res-334
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBPartitionKeyStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-335
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBQueryRuntimeStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-336
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CDBTableApiRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-337
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CHSMServiceOperationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-338
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CIEventsAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-339
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CIEventsOperational"
  to = azurerm_log_analytics_workspace_table_custom_log.res-340
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CassandraAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-341
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CassandraLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-342
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ChaosStudioExperimentEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-343
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CloudHsmHardwareOperationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-344
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CloudHsmServiceOperationAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-345
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ComputerGroup"
  to = azurerm_log_analytics_workspace_table_custom_log.res-346
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerAppConsoleLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-347
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerAppHTTPLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-348
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerAppSystemLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-349
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-350
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerImageInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-351
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerInstanceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-352
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-353
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-354
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerLogV2"
  to = azurerm_log_analytics_workspace_table_custom_log.res-355
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerNetworkLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-356
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerNodeInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-357
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerRegistryLoginEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-358
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerRegistryRepositoryEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-359
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ContainerServiceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-360
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/CoreAzureBackup"
  to = azurerm_log_analytics_workspace_table_custom_log.res-361
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DCRLogErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-362
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DCRLogTroubleshooting"
  to = azurerm_log_analytics_workspace_table_custom_log.res-363
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DNSQueryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-364
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DSMAzureBlobStorageLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-365
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DSMDataClassificationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-366
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DSMDataLabelingLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-367
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DataSetOutput"
  to = azurerm_log_analytics_workspace_table_custom_log.res-368
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DataSetRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-369
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DataTransferOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-370
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksAccounts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-371
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksApps"
  to = azurerm_log_analytics_workspace_table_custom_log.res-372
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksBrickStoreHttpGateway"
  to = azurerm_log_analytics_workspace_table_custom_log.res-373
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksBudgetPolicyCentral"
  to = azurerm_log_analytics_workspace_table_custom_log.res-374
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksCapsule8Dataplane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-375
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksClamAVScan"
  to = azurerm_log_analytics_workspace_table_custom_log.res-376
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksCloudStorageMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-377
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksClusterLibraries"
  to = azurerm_log_analytics_workspace_table_custom_log.res-378
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksClusterPolicies"
  to = azurerm_log_analytics_workspace_table_custom_log.res-379
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksClusters"
  to = azurerm_log_analytics_workspace_table_custom_log.res-380
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksDBFS"
  to = azurerm_log_analytics_workspace_table_custom_log.res-381
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksDashboards"
  to = azurerm_log_analytics_workspace_table_custom_log.res-382
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksDataMonitoring"
  to = azurerm_log_analytics_workspace_table_custom_log.res-383
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksDataRooms"
  to = azurerm_log_analytics_workspace_table_custom_log.res-384
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksDatabricksSQL"
  to = azurerm_log_analytics_workspace_table_custom_log.res-385
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksDeltaPipelines"
  to = azurerm_log_analytics_workspace_table_custom_log.res-386
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksFeatureStore"
  to = azurerm_log_analytics_workspace_table_custom_log.res-387
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksFiles"
  to = azurerm_log_analytics_workspace_table_custom_log.res-388
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksFilesystem"
  to = azurerm_log_analytics_workspace_table_custom_log.res-389
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksGenie"
  to = azurerm_log_analytics_workspace_table_custom_log.res-390
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksGitCredentials"
  to = azurerm_log_analytics_workspace_table_custom_log.res-391
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksGlobalInitScripts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-392
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksGroups"
  to = azurerm_log_analytics_workspace_table_custom_log.res-393
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksIAMRole"
  to = azurerm_log_analytics_workspace_table_custom_log.res-394
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-395
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksInstancePools"
  to = azurerm_log_analytics_workspace_table_custom_log.res-396
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksJobs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-397
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksLakeviewConfig"
  to = azurerm_log_analytics_workspace_table_custom_log.res-398
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksLineageTracking"
  to = azurerm_log_analytics_workspace_table_custom_log.res-399
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksMLflowAcledArtifact"
  to = azurerm_log_analytics_workspace_table_custom_log.res-400
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksMLflowExperiment"
  to = azurerm_log_analytics_workspace_table_custom_log.res-401
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksMarketplaceConsumer"
  to = azurerm_log_analytics_workspace_table_custom_log.res-402
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksMarketplaceProvider"
  to = azurerm_log_analytics_workspace_table_custom_log.res-403
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksModelRegistry"
  to = azurerm_log_analytics_workspace_table_custom_log.res-404
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksNotebook"
  to = azurerm_log_analytics_workspace_table_custom_log.res-405
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksOnlineTables"
  to = azurerm_log_analytics_workspace_table_custom_log.res-406
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksPartnerHub"
  to = azurerm_log_analytics_workspace_table_custom_log.res-407
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksPredictiveOptimization"
  to = azurerm_log_analytics_workspace_table_custom_log.res-408
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksRBAC"
  to = azurerm_log_analytics_workspace_table_custom_log.res-409
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksRFA"
  to = azurerm_log_analytics_workspace_table_custom_log.res-410
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksRemoteHistoryService"
  to = azurerm_log_analytics_workspace_table_custom_log.res-411
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksRepos"
  to = azurerm_log_analytics_workspace_table_custom_log.res-412
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksSQL"
  to = azurerm_log_analytics_workspace_table_custom_log.res-413
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksSQLPermissions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-414
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksSSH"
  to = azurerm_log_analytics_workspace_table_custom_log.res-415
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksSecrets"
  to = azurerm_log_analytics_workspace_table_custom_log.res-416
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksServerlessRealTimeInference"
  to = azurerm_log_analytics_workspace_table_custom_log.res-417
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksTables"
  to = azurerm_log_analytics_workspace_table_custom_log.res-418
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksUnityCatalog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-419
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksVectorSearch"
  to = azurerm_log_analytics_workspace_table_custom_log.res-420
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksWebTerminal"
  to = azurerm_log_analytics_workspace_table_custom_log.res-421
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksWebhookNotifications"
  to = azurerm_log_analytics_workspace_table_custom_log.res-422
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksWorkspace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-423
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DatabricksWorkspaceFiles"
  to = azurerm_log_analytics_workspace_table_custom_log.res-424
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DevCenterAgentHealthLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-425
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DevCenterBillingEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-426
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DevCenterConnectionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-427
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DevCenterDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-428
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DevCenterResourceOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-429
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DevOpsOperationsAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-430
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceBehaviorEntities"
  to = azurerm_log_analytics_workspace_table_custom_log.res-431
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceBehaviorInfo"
  to = azurerm_log_analytics_workspace_table_custom_log.res-432
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceCustomFileEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-433
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceCustomImageLoadEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-434
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceCustomNetworkEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-435
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceCustomProcessEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-436
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceCustomRegistryEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-437
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DeviceCustomScriptEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-438
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DiscoveryBookshelfAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-439
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DiscoverySupercomputerAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-440
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DiscoveryWorkspaceAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-441
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DragonCopilot"
  to = azurerm_log_analytics_workspace_table_custom_log.res-442
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/DurableTaskSchedulerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-443
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EGNFailedHttpDataPlaneOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-444
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EGNFailedMqttConnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-445
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EGNFailedMqttPublishedMessages"
  to = azurerm_log_analytics_workspace_table_custom_log.res-446
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EGNFailedMqttSubscriptions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-447
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EGNMqttDisconnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-448
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EGNSuccessfulHttpDataPlaneOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-449
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EGNSuccessfulMqttConnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-450
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ETWEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-451
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EdgeActionConsoleLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-452
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EdgeActionServiceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-453
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/EnrichedMicrosoft365AuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-454
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Event"
  to = azurerm_log_analytics_workspace_table_custom_log.res-455
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ExchangeAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-456
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ExchangeOnlineAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-457
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/FailedIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-458
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/FunctionAppLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-459
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/GraphNotificationsActivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-460
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightAmbariClusterAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-461
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightAmbariSystemMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-462
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightGatewayAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-463
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHBaseLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-464
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHBaseMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-465
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHadoopAndYarnLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-466
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHadoopAndYarnMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-467
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHiveAndLLAPLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-468
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHiveAndLLAPMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-469
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHiveQueryAppStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-470
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightHiveTezAppStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-471
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightJupyterNotebookEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-472
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightKafkaLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-473
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightKafkaMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-474
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightKafkaServerLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-475
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightOozieLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-476
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightRangerAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-477
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-478
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkApplicationEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-479
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkBlockManagerEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-480
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkEnvironmentEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-481
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkExecutorEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-482
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkExtraEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-483
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkJobEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-484
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-485
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkSQLExecutionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-486
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkStageEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-487
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkStageTaskAccumulables"
  to = azurerm_log_analytics_workspace_table_custom_log.res-488
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightSparkTaskEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-489
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightStormLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-490
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightStormMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-491
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HDInsightStormTopologyMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-492
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/HealthStateChangeEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-493
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Heartbeat"
  to = azurerm_log_analytics_workspace_table_custom_log.res-494
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/InsightsMetrics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-495
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/IntuneAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-496
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/IntuneDeviceComplianceOrg"
  to = azurerm_log_analytics_workspace_table_custom_log.res-497
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/IntuneDevices"
  to = azurerm_log_analytics_workspace_table_custom_log.res-498
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/IntuneOperationalLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-499
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/KubeEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-500
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/KubeHealth"
  to = azurerm_log_analytics_workspace_table_custom_log.res-501
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/KubeMonAgentEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-502
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/KubeNodeInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-503
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/KubePVInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-504
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/KubePodInventory"
  to = azurerm_log_analytics_workspace_table_custom_log.res-505
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/KubeServices"
  to = azurerm_log_analytics_workspace_table_custom_log.res-506
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/LAJobLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-507
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/LAQueryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-508
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/LASummaryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-509
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/LIATrackingEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-510
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/LedgerTransactionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-511
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/LedgerUserDefinedLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-512
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/LogicAppWorkflowRuntime"
  to = azurerm_log_analytics_workspace_table_custom_log.res-513
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MCCEventLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-514
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MCVPAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-515
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MCVPOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-516
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDCDetectionDNSEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-517
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDCDetectionFimEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-518
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDCDetectionGatingValidationEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-519
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDCDetectionK8SApiEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-520
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDCDetectionProcessV2Events"
  to = azurerm_log_analytics_workspace_table_custom_log.res-521
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDCFileIntegrityMonitoringEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-522
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDECustomCollectionDeviceFileEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-523
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MDPResourceLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-524
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MNFDeviceUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-525
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MNFSystemSessionHistoryUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-526
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MNFSystemStateMessageUpdates"
  to = azurerm_log_analytics_workspace_table_custom_log.res-527
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MPCAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-528
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MPCIngestionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-529
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MeshControlPlane"
  to = azurerm_log_analytics_workspace_table_custom_log.res-530
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftAzureBastionAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-531
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftDataShareReceivedSnapshotLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-532
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftDataShareSentSnapshotLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-533
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftDataShareShareLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-534
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftGraphActivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-535
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftGraphPolicyLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-536
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftHealthcareApisAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-537
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MicrosoftServicePrincipalSignInLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-538
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MySqlAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-539
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/MySqlSlowLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-540
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCBMBreakGlassAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-541
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCBMSecurityDefenderLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-542
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCBMSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-543
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCBMSystemLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-544
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCCIDRACLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-545
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCCKubernetesAPIAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-546
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCCKubernetesLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-547
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCCPlatformOperationsLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-548
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCCVMOrchestrationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-549
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCMClusterOperationsLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-550
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCSStorageAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-551
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCSStorageAudits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-552
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NCSStorageLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-553
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NGXOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-554
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NGXSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-555
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NSPAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-556
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NTAInsights"
  to = azurerm_log_analytics_workspace_table_custom_log.res-557
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NTAIpDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-558
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NTANetAnalytics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-559
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NTANspRuleRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-560
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NTARuleRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-561
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NTATopologyDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-562
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NWConnectionMonitorDNSResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-563
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NWConnectionMonitorDestinationListenerResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-564
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NWConnectionMonitorPathResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-565
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NWConnectionMonitorTestResult"
  to = azurerm_log_analytics_workspace_table_custom_log.res-566
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NatGatewayFlowlogsV1"
  to = azurerm_log_analytics_workspace_table_custom_log.res-567
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NetworkAccessAlerts"
  to = azurerm_log_analytics_workspace_table_custom_log.res-568
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NetworkAccessConnectionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-569
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NetworkAccessGenerativeAIInsights"
  to = azurerm_log_analytics_workspace_table_custom_log.res-570
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NetworkAccessTraffic"
  to = azurerm_log_analytics_workspace_table_custom_log.res-571
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/NginxUpstreamUpdateLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-572
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEPAirFlowTask"
  to = azurerm_log_analytics_workspace_table_custom_log.res-573
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEPAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-574
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEPDataplaneLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-575
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEPElasticOperator"
  to = azurerm_log_analytics_workspace_table_custom_log.res-576
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEPElasticsearch"
  to = azurerm_log_analytics_workspace_table_custom_log.res-577
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEWAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-578
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEWExperimentAssignmentSummary"
  to = azurerm_log_analytics_workspace_table_custom_log.res-579
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEWExperimentScorecardMetricPairs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-580
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OEWExperimentScorecards"
  to = azurerm_log_analytics_workspace_table_custom_log.res-581
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OGOAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-582
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OLPSupplyChainEntityOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-583
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OLPSupplyChainEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-584
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OTelEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-585
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OTelLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-586
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OTelResources"
  to = azurerm_log_analytics_workspace_table_custom_log.res-587
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OTelSpans"
  to = azurerm_log_analytics_workspace_table_custom_log.res-588
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OTelTraces"
  to = azurerm_log_analytics_workspace_table_custom_log.res-589
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OTelTracesAgent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-590
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Operation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-591
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/OracleCloudDatabase"
  to = azurerm_log_analytics_workspace_table_custom_log.res-592
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PFTitleAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-593
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLAutovacuumStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-594
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLDbTransactionsStats"
  to = azurerm_log_analytics_workspace_table_custom_log.res-595
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLPgBouncer"
  to = azurerm_log_analytics_workspace_table_custom_log.res-596
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLPgStatActivitySessions"
  to = azurerm_log_analytics_workspace_table_custom_log.res-597
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLQueryStoreQueryText"
  to = azurerm_log_analytics_workspace_table_custom_log.res-598
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLQueryStoreRuntime"
  to = azurerm_log_analytics_workspace_table_custom_log.res-599
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLQueryStoreWaits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-600
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PGSQLServerLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-601
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Perf"
  to = azurerm_log_analytics_workspace_table_custom_log.res-602
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PerfInsightsFindings"
  to = azurerm_log_analytics_workspace_table_custom_log.res-603
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PerfInsightsImpactedResources"
  to = azurerm_log_analytics_workspace_table_custom_log.res-604
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PerfInsightsRun"
  to = azurerm_log_analytics_workspace_table_custom_log.res-605
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PowerBIDatasetsTenant"
  to = azurerm_log_analytics_workspace_table_custom_log.res-606
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PowerBIDatasetsWorkspace"
  to = azurerm_log_analytics_workspace_table_custom_log.res-607
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PreAuthenticationDiscoveryLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-608
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PurviewDataSensitivityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-609
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PurviewScanStatusLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-610
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/PurviewSecurityLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-611
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/QuantumProviderAccountDeviceOperationLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-612
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/QuantumProviderAccountJobAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-613
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/QuantumProviderAccountQueueAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-614
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/QuantumProviderAccountTargetAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-615
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/QuantumWorkspaceJobAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-616
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/REDConnectionEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-617
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/RemoteNetworkHealthLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-618
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ResourceManagementPublicAccessLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-619
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/RetinaNetworkFlowLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-620
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SCCMAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-621
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SCGPoolExecutionLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-622
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SCGPoolRequestLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-623
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SCOMAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-624
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SPAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-625
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SQLAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-626
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SQLSecurityAuditEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-627
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SVMPoolExecutionLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-628
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SVMPoolRequestLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-629
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SecurityCaseEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-630
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ServiceFabricOperationalEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-631
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ServiceFabricReliableActorEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-632
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ServiceFabricReliableServiceEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-633
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SfBAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-634
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SfBOnlineAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-635
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SharePointOnlineAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-636
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SignalRServiceDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-637
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SigninLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-638
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageAntimalwareScanResults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-639
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageBlobLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-640
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageCacheOperationEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-641
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageCacheUpgradeEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-642
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageCacheWarningEvents"
  to = azurerm_log_analytics_workspace_table_custom_log.res-643
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageFileLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-644
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageMalwareScanningResults"
  to = azurerm_log_analytics_workspace_table_custom_log.res-645
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageMoverAuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-646
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageMoverCopyLogsFailed"
  to = azurerm_log_analytics_workspace_table_custom_log.res-647
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageMoverCopyLogsTransferred"
  to = azurerm_log_analytics_workspace_table_custom_log.res-648
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageMoverJobRunLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-649
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageQueueLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-650
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/StorageTableLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-651
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SucceededIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-652
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseBigDataPoolApplicationsEnded"
  to = azurerm_log_analytics_workspace_table_custom_log.res-653
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseBuiltinSqlPoolRequestsEnded"
  to = azurerm_log_analytics_workspace_table_custom_log.res-654
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseDXCommand"
  to = azurerm_log_analytics_workspace_table_custom_log.res-655
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseDXFailedIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-656
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseDXIngestionBatching"
  to = azurerm_log_analytics_workspace_table_custom_log.res-657
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseDXQuery"
  to = azurerm_log_analytics_workspace_table_custom_log.res-658
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseDXSucceededIngestion"
  to = azurerm_log_analytics_workspace_table_custom_log.res-659
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseDXTableDetails"
  to = azurerm_log_analytics_workspace_table_custom_log.res-660
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseDXTableUsageStatistics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-661
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseGatewayApiRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-662
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseIntegrationActivityRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-663
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseIntegrationPipelineRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-664
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseIntegrationTriggerRuns"
  to = azurerm_log_analytics_workspace_table_custom_log.res-665
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseLinkEvent"
  to = azurerm_log_analytics_workspace_table_custom_log.res-666
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseRbacOperations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-667
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseScopePoolScopeJobsEnded"
  to = azurerm_log_analytics_workspace_table_custom_log.res-668
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseScopePoolScopeJobsStateChange"
  to = azurerm_log_analytics_workspace_table_custom_log.res-669
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseSqlPoolDmsWorkers"
  to = azurerm_log_analytics_workspace_table_custom_log.res-670
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseSqlPoolExecRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-671
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseSqlPoolRequestSteps"
  to = azurerm_log_analytics_workspace_table_custom_log.res-672
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseSqlPoolSqlRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-673
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/SynapseSqlPoolWaits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-674
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Syslog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-675
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/TOUserAudits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-676
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/TOUserDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-677
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/TSIIngress"
  to = azurerm_log_analytics_workspace_table_custom_log.res-678
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCClient"
  to = azurerm_log_analytics_workspace_table_custom_log.res-679
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCClientReadinessStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-680
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCClientUpdateStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-681
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCDOAggregatedStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-682
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCDOStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-683
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCDeviceAlert"
  to = azurerm_log_analytics_workspace_table_custom_log.res-684
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCServiceUpdateStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-685
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/UCUpdateAlert"
  to = azurerm_log_analytics_workspace_table_custom_log.res-686
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Usage"
  to = azurerm_log_analytics_workspace_table_custom_log.res-687
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/VCoreMongoRequests"
  to = azurerm_log_analytics_workspace_table_custom_log.res-688
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/VIAudit"
  to = azurerm_log_analytics_workspace_table_custom_log.res-689
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/VIIndexing"
  to = azurerm_log_analytics_workspace_table_custom_log.res-690
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/VMBoundPort"
  to = azurerm_log_analytics_workspace_table_custom_log.res-691
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/VMComputer"
  to = azurerm_log_analytics_workspace_table_custom_log.res-692
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/VMConnection"
  to = azurerm_log_analytics_workspace_table_custom_log.res-693
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/VMProcess"
  to = azurerm_log_analytics_workspace_table_custom_log.res-694
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/W3CIISLog"
  to = azurerm_log_analytics_workspace_table_custom_log.res-695
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WOUserAudits"
  to = azurerm_log_analytics_workspace_table_custom_log.res-696
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WOUserDiagnostics"
  to = azurerm_log_analytics_workspace_table_custom_log.res-697
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDAgentHealthStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-698
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDAutoscaleEvaluationPooled"
  to = azurerm_log_analytics_workspace_table_custom_log.res-699
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDCheckpoints"
  to = azurerm_log_analytics_workspace_table_custom_log.res-700
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDConnectionGraphicsDataPreview"
  to = azurerm_log_analytics_workspace_table_custom_log.res-701
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDConnectionNetworkData"
  to = azurerm_log_analytics_workspace_table_custom_log.res-702
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDConnections"
  to = azurerm_log_analytics_workspace_table_custom_log.res-703
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDErrors"
  to = azurerm_log_analytics_workspace_table_custom_log.res-704
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDFeeds"
  to = azurerm_log_analytics_workspace_table_custom_log.res-705
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDHostRegistrations"
  to = azurerm_log_analytics_workspace_table_custom_log.res-706
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDManagement"
  to = azurerm_log_analytics_workspace_table_custom_log.res-707
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDMultiLinkAdd"
  to = azurerm_log_analytics_workspace_table_custom_log.res-708
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WVDSessionHostManagement"
  to = azurerm_log_analytics_workspace_table_custom_log.res-709
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WebPubSubConnectivity"
  to = azurerm_log_analytics_workspace_table_custom_log.res-710
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WebPubSubHttpRequest"
  to = azurerm_log_analytics_workspace_table_custom_log.res-711
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WebPubSubMessaging"
  to = azurerm_log_analytics_workspace_table_custom_log.res-712
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Windows365AuditLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-713
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Windows365CheckpointLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-714
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Windows365ConnectionErrorLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-715
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Windows365ConnectionLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-716
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/Windows365NetworkLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-717
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WindowsClientAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-718
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WindowsServerAssessmentRecommendation"
  to = azurerm_log_analytics_workspace_table_custom_log.res-719
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/WorkloadDiagnosticLogs"
  to = azurerm_log_analytics_workspace_table_custom_log.res-720
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ZTSGraph"
  to = azurerm_log_analytics_workspace_table_custom_log.res-721
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ZTSJobStatus"
  to = azurerm_log_analytics_workspace_table_custom_log.res-722
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ZTSMetadata"
  to = azurerm_log_analytics_workspace_table_custom_log.res-723
}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-ardl-1c6da0a56560fd63/providers/Microsoft.OperationalInsights/workspaces/laws1-sf5et/tables/ZTSRequest"
  to = azurerm_log_analytics_workspace_table_custom_log.res-724
}

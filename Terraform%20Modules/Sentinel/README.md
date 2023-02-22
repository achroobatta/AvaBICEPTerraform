There is no Sentinel module, use the resource provider directly. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sentinel_alert_rule_scheduled

# Sample code to use Azure Monitor LAW for Sentinel
```
resource "azurerm_log_analytics_solution" "example" {
  solution_name         = "SecurityInsights"
  location              = "Australia East"
  resource_group_name   = azurerm_resource_group.avatest.name
  workspace_resource_id = module.azure_monitor.law_out.id
  workspace_name        = module.azure_monitor.law_out.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
}

resource "azurerm_sentinel_alert_rule_scheduled" "example" {
  name                       = "example"
  log_analytics_workspace_id = azurerm_log_analytics_solution.example.workspace_resource_id
  display_name               = "example"
  severity                   = "High"
  query                      = <<QUERY
AzureActivity |
  where OperationName == "Create or Update Virtual Machine" or OperationName =="Create Deployment" |
  where ActivityStatus == "Succeeded" |
  make-series dcount(ResourceId) default=0 on EventSubmissionTimestamp in range(ago(7d), now(), 1d) by Caller
QUERY
}
```
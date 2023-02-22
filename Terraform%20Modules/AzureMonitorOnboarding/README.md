# Introduction 
Works with other modules to onboard diagnostics configuration with log analytics workspace, event hubs and storage account provisioned in AzureMonitor module.
As this module is not used directly in most circumstances, refer to other modules for enrolling them into Azure Monitor.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.1 | Jan23 | Update to use enabled_log as log is deprecated. | viktor.lee |
| 1.0 | July22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.1 | 1.3.7 | 3.40.0 |
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
| Module Name | Description | Tested Version |
|---|---|---|
| AzureMonitor | Required provisioning of required log analytics, event hub and storage account required for diagnostics logging | 1.0 |
| Other resource modules (e.g. VirtualNetwork) | Other resource modules will optionally call this module to onboard their resources for logging | 1.0 |

# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| resource_name | Name of the resource to enrol to Azure Monitor | string |
| resource_id | Resource id of the resource to enrol to Azure Monitor | string |
| log_analytics_workspace_id | log analytics workspace id to enrol to | string |



# Optional/Advance Parameters
Reference for Azure Monitor diagnostics setting resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting


| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| log_analytics_workspace_id | log analytics workspace id to enrol to | null | string |
| log_analytics_workspace_dedicated | Set to "Dedicated" to sent logs into resource specific tables in dedicated mode | null | string |
| diagnostics_logs_map | Mapping of logs and metrics to be configured for logging | {<br/>log = [<br/>#["Category name", "Retention Enabled", Retention period] <br/>#["kube-apiserver", true, 30],<br/>]<br/>metric = [<br/>#["Category name", "Retention Enabled", Retention period] <br/>#["AllMetrics", true, 30],<br/>]<br/>} |
| diagnostics_map | mapping of the storage account and event hub to be used for diagnostics | {<br/>diags_sa = null<br/>eh_id    = ""<br/>eh_name  = null<br/>} | any {<br/>diags_sa = ""<br/>eh_id    = ""<br/>eh_name  = ""<br/>} |

# Outputs
There are no outputs

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

# Additional details
## Sample usage when using this module in your own modules
```
module "vnet_diag" {
  count = var.azure_monitor != null ? 1 : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_virtual_network.vnet.name
  resource_id                = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name",  "Diagnostics Enabled", "Retention Enabled", Retention period] 
      ["VMProtectionAlerts", true, true, var.logging_retention],
    ]
    metric = [
      ["AllMetrics", true, true, var.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}
```
## Sample usage when using this module in your TF config outside of modules
```
module "aspfrontend_diag" {
  source                     = "../Terraform Modules/AzureMonitorOnboarding/"
  resource_name              = azurerm_service_plan.frontend.name
  resource_id                = azurerm_service_plan.frontend.id
  log_analytics_workspace_id = module.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name",  "Diagnostics Enabled", "Retention Enabled", Retention period] 
    ]
    metric = [
      ["AllMetrics", true, true, local.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = null
    eh_id    = null
    eh_name  = null
  }
}
```
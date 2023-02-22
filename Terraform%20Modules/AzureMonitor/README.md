# Introduction 
Provision log analytics, and optional storage account and event hub resources required for Azure monitoring.
Storage account and event hub namespace name will be appended with a number 0 to 999 at the end to reduce chance of name conflict.
Optional creation of log analytics to create VM Insights solutions, defaults to true unless specified to false.
Forces storage account to only use https.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
| Module Name | Description | Tested Version |
|---|---|---|
| AzureMonitorOnboarding | Optional onboard and configure diagnostics to resources provisioned by this module | 1.1 |

# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| name | Name to be used for log analytics, event hub and storage account resources | string |
| location | Azure region of where to provision the resources | string |
| resource_group_name | Name of the RG| string |
| tags | Azure Tags | map |


# Optional/Advance Parameters
Reference for event hub namespace resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace

Reference for event hub resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub

Reference for log analytics workspace resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace

Reference for storage account resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account


| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| log_analytics_workspace_sku | Log analytics workspace sku  | "PerGB2018" | string |
| log_analytics_workspace_retention | Log analytics workspace retention period in days  | 30 | number |
| log_analytics_workspace_daily_quota | Log analytics workspace daily quota in GB  | -1 | number |
| log_analytics_workspace_ingestion | Log analytics workspace ingestion over the internet  | true | boolean |
| log_analytics_workspace_query | Log analytics workspace query over the internet  | true | boolean |
| log_analytics_workspace_reservation| Log analytics workspace reservation in GB if sku is set to "CapacityReservation" | null | number |
| eventhub_required | Eventhub required? Makes all eventhub optional parameters invalid if set to false  | false | bool |
| eventhub_sku | Eventhub sku  | "Basic" | string |
| eventhub_parition_count | Eventhub partition count  | 4 | number |
| eventhub_capacity | Eventhub partition capacity if sku is "Standard" | 2 | number |
| eventhub_zone_redundant | Eventhub zone redundancy | false | bool |
| eventhub_auto_inflate | Eventhub auto inflate settings | false | bool |
| eventhub_throughput | Eventhub throughput if auto inflate is set to true | null | number |
| eventhub_dedicated_cluster | Eventhub dedicated cluster id | null | string|
| eventhub_message_retention | Eventhub throughput if auto inflate is set to true | 1 | number |
| eventhub_status | Eventhub status | "Active" | string |
| eventhub_network_rules | Configure to turn on network rule and define the allowed network access for ip address,subnet ids or trusted Azure services. Refer to event hub resource provider for usage details.  | null | object({<br/>trusted_service_access_enabled = bool<br/>ip_rules   = list(string)<br/>subnet_ids = list(string)<br/>}) |
| storage_account_required | Storage account required? Makes all storage account optional parameters invalid if set to false | false | bool |
| storage_account_tier | Storage account sku  | "Standard" | string |
| storage_account_replication_type | Storage account replication type  | "LRS" | string |
| storage_account_kind | Storage account kind  | "StorageV2" | string |
| storage_account_access_tier | Storage account access tier  | "Cool" | string |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| law_out | Output the object of log analytics workspace | any |
| sa_out | Output the object of storage account | any |
| ehnamespace_out | Output the object of event hub namespace | any |
| eh_out | Output the object of event hub | any |

# Additional details
## Basic sample usage code
```
module "azure_monitor" {
  source = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//AzureMonitor"
  name = "avatest"
  location = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
}
```
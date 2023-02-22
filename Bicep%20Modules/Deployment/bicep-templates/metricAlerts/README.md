# Introduction 
This template will configure metrics for various resources in Azure.
## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
| logAnalytics | Provision log analytics workspace |  |
| StorageAccount | Provision storage account | |


## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| actionGroupName | name of the metric action group | string |
| name | name of the resource for which metrics have to be enabled | string |
| autoMitigate | auto mitigate | boolean | 
| enabled | enable? | boolean |
| evaluationFrequency | evaluation frequency | string | 
| windowSize | window size | string | 
| scopes | resource scope | string |
| targetResourceType | resource for which the metrics are enabled | string | 
| targetResourceRegion | location fo the target resource | string |
| threshold | threshold | number |
| metricNamespace | metric namepace | string |
| timeAggregation | time aggregation | string |
| metricName | metric name | string |
| operator | logical operator | string |
| criterionType | criteria type | string |
| dimensions | dimensions | string |
## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

## Additional details
### Sample usage when using this module in your own modules

```

```

## References

- Cannot select resources from multiple locations

Your selection has resources from multiple locations. To alert on metrics, use the location filter to proceed. To alert on activity logs, select a single resource or single resource group or subscription

SCope can be set on resource group


Metrics are here (e.g. this is for firewall)

https://docs.microsoft.com/en-us/azure/azure-monitor/essentials/metrics-supported#microsoftnetworkazurefirewalls


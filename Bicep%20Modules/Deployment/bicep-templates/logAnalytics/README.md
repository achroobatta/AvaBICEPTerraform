# Introduction 
This template will deploy an Azure Log Analytics workspace.
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
| StorageAccount | Provision storage account | |


## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| workspaceObject | parameters for log analytics workspace | object | 
| location | location of the resource | string |
| name | name of the resource | string |
| tags | tags fo the resource | object |
| sku | sku of the resource | object | 
| retentionInDays | retention period for the logs | number |

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


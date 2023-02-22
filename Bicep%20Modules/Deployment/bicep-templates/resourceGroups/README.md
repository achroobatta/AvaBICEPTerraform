# Introduction 
This template will deploy a resource group in a subscription

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August25 | First release | eashan.nakar |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
||||

### Create resources using Azure Portal as well as Azure CLI and Azure Powershell commands: 
- [See this document for creating resource groups via](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal):
    - Portal
    - Azure CLI
    - Powershell 
    ```
## Required Parameters

Resource group naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| name | The name of the resource group  |  string |
| owner| The owner of the resource group |  string |
| costcentre | The part of organisation to which the cost is attributable |  string |
| application | The application for which the resource group is created |  string |
| builtin | If 'True' then a policy is activiated that will report if the location of the resource group and resource does not match | boolean |


## Optional/Advance Parameters

There are no advance or optional Parameters.

## Additional details
### Sample usage when using this module in your own modules
## References

- [What is a resource group?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#what-is-a-resource-group)
- [Creating a resource group?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups)
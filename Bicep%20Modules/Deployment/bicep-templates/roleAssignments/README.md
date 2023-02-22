# Introduction 
This template will assign role assingments to a resource group

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August31 | First release | eashan.nakar |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
||||

### Assign Azure roles to resource groups using Azure Portal as well as Azure CLI and Azure Powershell commands: 
- [See this document for creating resource groups via](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=current):
    - Portal
    - Azure CLI
    - Powershell
    - REST API
    - ARM template 
## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| roleAssignmentObject | The object consists of the following parameters: name, resourceGroup, roleId, principalId, principalType | string|

## Optional/Advance Parameters

There are no advance or optional Parameters.

## Additional details
### Sample usage when using this module in your own modules
## References
[Select the appropriate scope](https://docs.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal?tabs=current#step-3-select-the-appropriate-role)
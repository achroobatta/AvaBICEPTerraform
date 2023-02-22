
# Introduction 
This template will deploy action groups in the resource group.

When Azure Monitor data indicates that there might be a problem with your infrastructure or application, an alert is triggered. Azure Monitor, Azure Service Health, and Azure Advisor then use action groups to notify users about the alert and take an action. An action group is a collection of notification preferences that are defined by the owner of an Azure subscription.

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | Aug22 | First release | su.myat.khine.win |

## Developed On
| Module Version | Bicep Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
|SQL Server|Create the SQL server which acts as a Logical server.||

### Create resources using Azure cli and Azure Powershell commands 
- [az monitor action-group](https://docs.microsoft.com/en-us/cli/azure/monitor/action-group?view=azure-cli-latest):
- [Create and manage action groups in the Azure portal](https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)
    - Portal
    - Azure cli



## Required Parameters


| Parameter Name | Description |  Type | 
|---|---|---|
| actionGroupsObject | The object that contains name, smsReceivers, emailReceivers (emailAddress, name, countryCode, phoneNumber) | Object |
|environmentType| Type of environment the action gets deployed to|
|deployDate|Deployment Date|


## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
||||

## Additional details

## References

- [Action group name](https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/action-groups)




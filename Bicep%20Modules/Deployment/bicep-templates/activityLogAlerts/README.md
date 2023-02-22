# Introduction 
There are four types of alerts in Azure. They are :
- Metric alerts
- Log alerts 
- Activity log alerts
- Smart detection alerts.

[Out of the following four types, this template will deploy Activity Log alert.
Activity logs provide auditing of all actions that occurred on resources. Use activity log alerts to be alerted when a specific event happens to a resource, for example, a restart, a shutdown, or the creation or deletion of a resource](https://docs.microsoft.com/en-us/azure/azure-monitor/alerts/alerts-types).

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August22 | First release | su.myat.khine.win |

## Developed On
| Module Version | Bicep Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
||||

### Create resources using Azure cli and Azure Powershell commands 


## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| activityLogAlertsObject | This object contains activityLogAlerts consisting of enabled, actionGroupName, name, scopes, conditions (field, equals).|  object |
|activityLogAlerts - enabled|ActivityLogEnabled|boolean|
|activityLogAlerts - actionGroupName|Action group name|string|
|activityLogAlerts - scopes| scope of the alert|string|
|activityLogAlerts - conditions|Array consists of field and equals|array|
|activityLogAlerts - |||
| tags | Tags for object|  string |
| name | Activity Log Alerts |  string |


## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

## Additional details
### Sample usage when using this module in your own modules


## References

- [Quickstart: Create activity log alerts on service notifications using a Bicep file](https://docs.microsoft.com/en-us/azure/service-health/alerts-activity-log-service-notifications-bicep?tabs=CLI)



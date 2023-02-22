# Introduction 
This template will...

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August26 | First release | eashan.nakar |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
||||

## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| scheduledQueryRulesObject | This objects consists of the following parameters: scope, properties (description, displayName, enabled, evaluationFrequency, severity, autoMitigate, checkWorkspaceAlertsStorageConfigured, windowsSize, actions, criteria) | object |
| dimensions |  | array |
| tags | The key-value pair that is assigned to the resource | object |
| name | The name of the resource | string |
| workspaceGroup | Params from the global.yml | string|
| workspaceName | Params from the global.yml | string |
| location | The geo-location of the resource | string |

## Optional/Advance Parameters

There are no advance or optional Parameters.

## Additional details
### Sample usage when using this module in your own modules
## References
[Microsoft Documentation](https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/scheduledqueryrules?pivots=deployment-language-bicep)
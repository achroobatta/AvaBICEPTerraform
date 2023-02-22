# Introduction 
This template will deploy app insights and app insights diagnostics.

[Application Insights is a feature of Azure Monitor that provides extensible application performance management (APM) and monitoring for live web apps.](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)

| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | August22 | First release | su.myat.khine.win |

## Module Dependencies
- Log analytics workspace

## Create resources using Azure portal, cli and Azure Powershell commands 
- [Workspace-based Application Insights resources](https://docs.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource)
- [Workspace-based Application Insights resources](https://docs.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource)

## Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|---|
| appInsightsName|Name of Application Insights resource.|string|
|appInsightsType|Type of app you are deploying. This field is for legacy reasons and will not impact the type of App Insights resource you deploy.|string|
|appInsightsKind|Kind of app you are deploying. The kind of application that this component refers to, used to customize UI. This value is a freeform string, values should typically be one of the following: web, ios, other, store, java, phone.|string|
|appInsightsFlowType|Type of flow for the App insights Instance|string|
|location|Which Azure Region to deploy the resource to. This must be a valid Azure regionId|string|
|resourceTags|This object contains Project, Stream and Zone.|object|
|appInsightsRequestSource|Source of Azure Resource Manager deployment|string|
|diagnostics|This object contains subscription, resourceGroup, workspaceName, and storageAccount (all are string type)| object|


## Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

## References
- [Appinsights overview](https://docs.microsoft.com/en-us/azure/azure-monitor/app/app-insights-overview)
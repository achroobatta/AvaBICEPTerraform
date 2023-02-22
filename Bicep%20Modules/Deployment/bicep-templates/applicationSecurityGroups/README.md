# Introduction 
This template will deploy Application Security Groups template. 

[Application security groups enable you to configure network security as a natural extension of an application's structure, allowing you to group virtual machines and define network security policies based on those groups.](https://docs.microsoft.com/en-us/azure/virtual-network/application-security-groups)

| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | August22 | First release | su.myat.khine.win |

## Module Dependencies
- None

## Create resources using Azure portal, cli and Azure Powershell commands 
- [Workspace-based Application Insights resources](https://docs.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource)
- [Workspace-based Application Insights resources](https://docs.microsoft.com/en-us/azure/azure-monitor/app/create-workspace-resource)

## Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|---|
|asgObject|This application security group (ASG) object contains asg array which lists various servers and workstations| object|
|location| Location of ASG|string|
|environmentType|Environment Type|string|
|deployDate|Deployment date|string|
|asgPrefix| ASG prefix from global yml file|string|
|networkGroup|Network group|string|


## Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

## References
- [Application security groups](https://docs.microsoft.com/en-us/azure/virtual-network/application-security-groups)
- 
# Introduction 
This template will deploy Application Security Groups template. 

- [An availability set is a logical grouping of VMs that allows Azure to understand how your application is built to provide for redundancy and availability.Each virtual machine in the availability set is assigned an update domain and a fault domain by the underlying Azure platform.](https://docs.microsoft.com/en-us/azure/virtual-machines/availability-set-overview)
- Update domains indicate groups of virtual machines and underlying physical hardware that can be rebooted at the same time.
- Fault domains define the group of virtual machines that share a common power source and network switch. 

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
|avsObject|Availability Sets object contains an array of various servers and workstations with faultDomains and updateDomains assigned to them.|object|
|location|Location|string|
|environmentType|Environment Type|string|
|deployDate|Deployment date|string|
|asvPrefix| AVS from global.yml file|string|
|computeGroup|computeGroup from global.yml file|string|
# Introduction 
This template will deploy Application Security Groups template. 


## Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

## References
- [Application security groups](https://docs.microsoft.com/en-us/azure/virtual-network/application-security-groups)
- 

## Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

## References
- [Availability sets](https://docs.microsoft.com/en-us/azure/virtual-machines/availability)

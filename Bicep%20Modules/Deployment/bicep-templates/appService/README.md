# Introduction 
This folder contains two templates:
    - az-ase3.bicep : this template deploys App Service, App Service Plan, App Insights and Diagnostics 
    - subnetNameDelegation.bicep

- Azure App Service is a fully managed platform as a service (PaaS) offering, and an HTTP-based service for hosting web applications, REST APIs, and mobile back ends. You can develop in your favorite language, be it .NET, .NET Core, Java, Ruby, Node.js, PHP, or Python. Applications run and scale with ease on both Windows and Linux-based environments.

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August22 | First release | su.myat.khine.win |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
||||

### Create resources using Azure cli and Azure Powershell commands 
    - Portal
    - [Azure cli](https://docs.microsoft.com/en-us/azure/app-service/provision-resource-bicep)


## Required Parameters
### az-asev3.bicep (ASEv3 Deployment with App Service, App Service Plan, App Insights and Diagnostics)

| Parameter Name | Description |  Type | 
|---|---|---|
|location|Required. Location for all resources.  |string  |
|vNetResourceGroupName|Resource Group name of virtual network if using existing vnet and subnet.|string|
|diagnostics |This parameter specifies the diagnostics and aseDiagSettingName. It includes subscription, resourceGroup, workspaceName, storageAccount|object|
|aseDiagSettingName|Diagnostic Setting name| string|
|useExistingVnetandSubnet| This parameter ensures the uses existing virtual network and subnet |true|
|Name of virtual network |virtualNetworkName|string|
|virtualNetworkAddressSpace|An Array of 1 or more IP Address Prefixes for the Virtual Network.|string|
|subnetAddressSpace|The subnet Address Space Name of ASEv3|string|
|subnetName|The subnet Name of ASEv3|string|
|subnets |The subnet properties array consisting of one object : name, addressPrefix, delegations array (name, properties (serviceName), privateEndpointNetworkPolicies, privateLinkServiceNetworkPolicies.|arrays|
|Web App Name|Name of the web app|string|
|webAppDiagSettingName |Web app diagnostic setting|string|
|AppInsightName|App Insight Name |string|
|AppInsightDiagSettingName|App Insight Diagnostic Setting|string|
|requestSource|Source of Azure Resource Manager deployment|string|
|type|Type of app you are deploying. This field is for legacy reasons and will not impact the type of App Insights resource you deploy|string|
|resourceTags|resourceTags object consists of project, stream, zone, environment|object|
|sku |a purchasable SKU (Stock-keeping-Unit) under App Service |string|
|skuCode| sku product code|string|
|appServicePlanName|The name of the App Service plan to use for hosting the web app|string|
|appServicePlanDiagSettingNam|appServicePlanDiagSettingName|string|
|aseName|Required. Name of ASEv3|string|
|dedicatedHostCount|Dedicated host count of ASEv3.|string|
|zoneRedundant|Zone redundant of ASEv3|boolean|
|currentStack||string|
|phpVersion|PHP version|string|
|netFrameworkVersion |.net FrameworkVersion |string|
|alwaysOn||boolean|
|workerSize|[The worker size of the app service plan is expressed in within the app service plan pricing tier. Small, Medium, & Large correspond to 1, 2, 3 respectively in the pricing plan tier on dedicated hardware.](https://docs.microsoft.com/en-us/answers/questions/257485/app-service-worker-size-gt-pricing-tiers-translati.html)|string|
|workerSizeId||string|
|numberOfWorkers | Number of workers - [Applications run on Windows servers and are referred to as Web Workers or Workers for short. The majority of servers in a given scale unit are Workers. Workers are the backbone of the App Service scale unit. ](https://docs.microsoft.com/en-us/archive/msdn-magazine/2017/february/azure-inside-the-azure-app-service-architecture)|string|
|internalLoadBalancingMode|Load balancer mode: 0-external load balancer, 3-internal load balancer for ASEv3|int|

### subnetNameDelegation.bicep

| Parameter Name | Description |  Type | 
|---|---|---|
|virtualNetworkName|The Virtual Network (vNet) Name|string|
|subnetName|The subnet Name of ASEv3|string|
|subnetAddressSpace|The subnet Name Address Space of ASEv3.|string|

## Optional/Advance Parameters

There are no advance or optional Parameters.


## Additional details
### Sample usage when using this module in your own modules


## References

- [Create App Service app using Bicep](https://docs.microsoft.com/en-us/azure/app-service/provision-resource-bicep)
- [App Service overview](https://docs.microsoft.com/en-us/azure/app-service/overview)
- [azure-quickstart-templates/quickstarts/microsoft.web/app-service-docs-linux/README.md](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.web/app-service-docs-linux/README.md)



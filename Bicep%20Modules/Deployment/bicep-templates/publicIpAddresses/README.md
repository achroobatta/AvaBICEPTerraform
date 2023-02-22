# Introduction 
This template will deploy PublicIPAddresses in  resource group. 

Public IP addresses allow Internet resources to communicate inbound to Azure resources. Public IP addresses enable Azure resources to communicate to Internet and public-facing Azure services. The address is dedicated to the resource, until it's unassigned by you. A resource without a public IP assigned can communicate outbound. Azure dynamically assigns an available IP address that isn't dedicated to the resource. For more information about outbound connections in Azure, see Understand outbound connections

More details about Public IP Addresses in Azure can be referred [here](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/public-ip-addresses)

Please refer `publicIPAddresses.ae.parameters.json` and `publicIPAddresses.ase.parameters.json` for more details about the parameters

## Version
| Version | Date | Release Notes | Author
|---|---|---|---|
| 1.0.0 | Aug22 | First release | Rama Balla


## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0.0 | |


## Module Dependencies
| Module Name | Description | Tested Version | 
|---|---|---|
| [StorageAccount](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview) | To store all of your Storage data objects, including blobs, file shares, queues, tables, and disks. The storage account provides a unique namespace for your Azure Storage data that's accessible from anywhere in the world over HTTP or HTTPS. Data in your storage account is durable and highly available, secure, and massively scalable||
| [LogAnalytics Worksapce](https://docs.microsoft.com/en-us/azure/azure-monitor/logs/log-analytics-workspace-overview) | To log data from Azure Monitor and other Azure services, such as Microsoft Sentinel and Microsoft Defender for Cloud. Each workspace has its own data repository and configuration but might combine data from multiple services |


### Create PublicIPAddresses using Azure cli, Azure Powershell commands or Azure Portal 
- [Azure CLI](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-cli?tabs=create-public-ip-standard%2Ccreate-public-ip-zonal%2Crouting-preference)
- [Azure PowerShell](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-powershell?tabs=create-public-ip-standard%2Ccreate-public-ip-zonal%2Crouting-preference)
- [Azure portal](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-portal?tabs=option-1-create-public-ip-standard)


## Required Parameters
| Parameter Name | Description |  Type | 
|---|---|---|
| pipObject | The object that contains several properties for the PublicIPObject | Object |
|location| Location where the resources get deployed | string
|deployDate|Deployment Date| string
|environmentType| Type of environment the action gets deployed to|
|deployDate|Deployment Date| string
|pipPrefix|Params from the global.yml|string|
|networkGroup|Params from the global.yml|string|
|workspaceName|Params from the global.yml|string|
|workspaceGroup|Params from the global.yml|string|
|hubSubscription|Params from the global.yml|string|
|loggingStorageAccountName|Params from the global.yml|string|
|loggingStorageAccountGroup|Params from the global.yml|string|

## Optional/Advance Parameters
- There are no advance or optional Parameters.

## Outputs
- There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
||||


## Additional details
- None

## References
- [Azure CLI](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-cli?tabs=create-public-ip-standard%2Ccreate-public-ip-zonal%2Crouting-preference)
- [Azure PowerShell](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-powershell?tabs=create-public-ip-standard%2Ccreate-public-ip-zonal%2Crouting-preference)
- [Azure portal](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-portal?tabs=option-1-create-public-ip-standard)
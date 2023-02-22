# Introduction 
This template will deploy Network Security Groups in  resource group. 

Azure network security groups used to filter network traffic between Azure resources in an Azure virtual network. A network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. For each rule, you can specify source and destination, port, and protocol.

How NSGs filter Network Traffic can be referenced [here](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-group-how-it-works)

Please refer `networkSecurityGroups.ae.parameters.json` and `networkSecurityGroups.ase.parameters.json` for the security rules defined in detail

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



### Create NSGs using Azure cli, Azure Powershell commands or Azure Portal 
- [az network nsg create](https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group)
- [New-AzNetworkSecurityGroup](https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group)
- [Create and manage NSGs in the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group)


## Required Parameters
| Parameter Name | Description |  Type | 
|---|---|---|
| nsgObject | The object that contains several NSG Rules with `enableFlowLogs` is set to `true` and `flowLogsStorageRetention` is set to `7` (Please refer `networkSecurityGroups.ae.parameters.json` and `networkSecurityGroups.ase.parameters.json` for more details) | Object |
|location| Location where the resources get deployed | string
|deployDate|Deployment Date| string
|environmentType| Type of environment the action gets deployed to|
|deployDate|Deployment Date| string
|nsgPrefix|Params from the global.yml|string|
|flPrefix|Params from the global.yml|string|
|networkGroup|Params from the global.yml|string|
|workspaceName|Params from the global.yml|string|
|workspaceGroup|Params from the global.yml|string|
|hubSubscription|Params from the global.yml|string|
|loggingStorageAccountName|Params from the global.yml|string|
|loggingStorageAccountGroup|Params from the global.yml|string|

## Optional/Advance Parameters
There are no advance or optional Parameters.

## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
||||


## Additional details
None

## References
- [az network nsg create](https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group)
- [New-AzNetworkSecurityGroup](https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group)
- [Create and manage NSGs in the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-network/manage-network-security-group)
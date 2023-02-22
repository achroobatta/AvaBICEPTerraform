# Introduction 
This template deploys the virtual network and their components like subnet, networkInterface and etc. 

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August26 | First release | eashan.nakar |

# Module Dependencies
Create resource group before deploying this resource using:

| Azure CLI |
|---|
az group create --name demoResourceGroup --location <region>

| Azure Powershell |
|---|
New-AzResourceGroup -Name exampleGroup -Location <region>

### Create route tables using Azure CLI and Azure Powershell commands 
- [See this document for creating route tables via](https://docs.microsoft.com/en-us/azure/virtual-network/quick-create-portal):
    - Portal
    - Azure CLI
    - Powershell 
    ```

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|---|
| vnetName | The vnet object which consists of the following parameters: name, addressPrefix, dnsServer array, subnets (name, addressPrefix, privateEndpointNetworkPolicies, privateLinkServiceNetworkPolicies, nsgName, builtin)  | string |
| location | The geo-location of the vnet | string |
| name | The name of the resource | string |
| tags | The key-value pair associated with the resource | object |
|snPrefix | Params from the global.yml  |string
|nsgPefix | Params from the global.yml  |string
|workspaceName | Params from the global.yml  |string|
|workspaceGroup | Params from the global.yml  |string|
|hubSubscription | Params from the global.yml  |string|
|loggingStorageAccountName | Params from the global.yml |string|
|loggingStorageAccountGroup | Params from the global.yml  |string|

# Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

# References
[What is a vnet](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
[Creating vnet resource with Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/scenarios-virtual-networks)

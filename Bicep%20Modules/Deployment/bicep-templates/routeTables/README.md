# Introduction 
This template will deploy a Route Table in the resource group. 

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August31 | First release | eashan.nakar |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0.0 | |

## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
||||

### Create resources using Azure CLI and Azure Powershell commands 
- [See this document for creating route tables via](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart?view=azuresql&tabs=azure-powershell):
    - Portal
    - Azure CLI
    - Azure CLI (SQL up)
    - Powershell 
    ```
## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| rtObject | The route table object which consists of the following parameters: name, disableBgpRoutePropagation, flowLogsStorageRetention, enableDeleteLock, routes (addressPrefix, hasBgpOverride, nextHopIpAddress, nextHopType)  string |
| networkGroup | Params from the global.yml | string | 
| fwPrefix | Params from the global.yml | string |
| rtPrefix | Params from the global.yml | string |
| udrPrefix | Params from the global.yml | string |
| location | The location of the route table | string |
| tags | A key-value pair associated with the rtObject  | object


## Optional/Advance Parameters
There are no advance or optional Parameters.
## Additional details
### Sample usage when using this module in your own modules
```

```
## References

- [azure-quickstart-templates/quickstarts/microsoft.network/route-table-create/azuredeploy.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.network/route-table-create/azuredeploy.json)
- [Route table template](https://github.com/dylom/AzureARMTemplate/blob/e27858bc880531f7a22d80fb9dda9d5666970c5f/quickstarts/microsoft.network/route-table-create/azuredeploy.json)

- [Tutorial: Route network traffic with a route table using the Azure portal](https://docs.microsoft.com/en-us/azure/virtual-network/tutorial-create-route-table-portal)
- [Microsoft.Network routeTables & RoutePropertiesFormat](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/routetables?tabs=bicep)
-[Flow Logging for NSG](https://docs.microsoft.com/en-us/azure/network-watcher/network-watcher-nsg-flow-logging-overview)
---
# Introduction 
This template will deploy a Route Table in the resource group. 

- Modify this

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | su.myat.khine.win |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |

## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
||There is no module dependency.||

### Create resources using Azure cli and Azure Powershell commands 
- [See this document for creating the SQL single database via](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart?view=azuresql&tabs=azure-powershell):
    - Portal
    - Azure cli
    - Azure cli (SQL up)
    - Powershell 
    ```


## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| routeTableName | Route table name |  string |
| location | Route table resource location |  bool |
| disableBgpRoutePropagation | Disable the routes learned by BGP on the route table |  string |
| routes | Array containing routes and route propertiesformat - addressPrefix, hasBgpOverride, nextHopIpAddress, nextHopType|  string |
| enableDeleteLock | Enable delete lock |  bool |


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

- Videos resources
    - [Azure SQL Managed Instance Overview | Azure SQL for beginners (Ep. 6)](https://www.youtube.com/watch?v=VM0eiOmE35I&list=PLlrxD0HtieHi5c9-i_Dnxw9vxBY-TqaeN&index=6)
    - []()
---

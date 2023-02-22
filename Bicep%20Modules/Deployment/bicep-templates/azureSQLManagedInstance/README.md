# Introduction 
This template will deploy an Azure SQL Managed Instance.
## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | Sep22 | First release | santosh.manne |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
| Vnet | Provision virtual network |  |
| Subnets | Provision subnets | |
| NSG | Network security group |  |
| routeTable | route table |  | 


## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| location | location of the resource | string |
| addressPrefix | address prefix of the subnet | string |
| subnetName | name of the subnet | string |
| subnetPrefix | subnet prefix address | string |
| networkSecurityGroupName | name of the NSG | string |
| miName | name of the Sql Managed Instance | string |
| skuName | sku of the Sql Managed Instance | string |
| administratorLogin | sql admin username | string |
| administratorLoginPassword | sql admin password | string |
| virtualNetworkName | name of the virtual network | string |
| vCores | No of cores for the Sql Managed Instance | integer | 
| licenseType | license type | string |
| routeTableName | Name of the route table | string |

## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

## Additional details
### Sample usage when using this module in your own modules

```

```

## References

- What is Azure Sql Managed Instance? https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql




## References
- [saikovvuri/azureSqlManagedInstance](https://github.com/saikovvuri/azureSqlManagedInstance/tree/main)
# Introduction 
This template will deploy an Azure SQL server and Azure SQL database in the resource group.
The user is given the choice of creating multiple databases. This can be achieved by supplying the database names to the parameter "databasenames", which takes the value as an array.
Optionally, the user can create a SQL failover group via the module. To create the failover group, the user must supply the value "true" to the parameter "failover_required" and subsequently give the required parameters.


## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | September22 | First release | santosh.manne |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
|SQL Server|Create the SQL server which acts as a Logical server.||

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
| primarySqlServerName | The name of the primary SQL logical server |  string |
| secondarySqlServerName | The name of the secondary server | string |
| primaryLocation | Location of the primary sql server | string |
| secondaryLocation | Location of the secondary sql server | string |
| databaseNames | The names of the SQL Databases |  array |
| administratorLogin | The administrator username of the SQL logical server. |  string |
| administratorLoginPassword | The administrator password of the SQL logical server |  string |
| sku | sku of the sql database | object |
| failover_required | enable failover group? | boolean |
| failoverGroupName | Name of the failover group | string |


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

- [What is Azure SQL?](https://docs.microsoft.com/en-us/azure/azure-sql/azure-sql-iaas-vs-paas-what-is-overview?view=azuresql)
- [Quickstart: Create a single database in Azure SQL Database using an ARM template](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-create-arm-template-quickstart?view=azuresql)
- [azure-quickstart-templates/quickstarts/microsoft.sql/sql-database/main.bicep](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.sql/sql-database/main.bicep)
- [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [What is a single database in Azure SQL Database?](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-overview?view=azuresql)
- [DevOps for Azure SQL](https://devblogs.microsoft.com/azure-sql/devops-for-azure-sql/)
- [Continuous Delivery for Azure SQL DB using Azure DevOps Multi-stage Pipelines](https://devblogs.microsoft.com/azure-sql/continuous-delivery-for-azure-sql-db-using-azure-devops-multi-stage-pipelines/)



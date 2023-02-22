# Introduction 
This template will deploy an Azure SQL database in the resource group.

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
| serverName | The name of the SQL logical server |  string |
| sqlDBName | The name of the SQL Database |  string |
| location | Location for all resources |  string |
| administratorLogin | The administrator username of the SQL logical server. |  string |
| administratorLoginPassword | The administrator password of the SQL logical server |  string |


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
- [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming)
- [What is a single database in Azure SQL Database?](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-overview?view=azuresql)
- [DevOps for Azure SQL](https://devblogs.microsoft.com/azure-sql/devops-for-azure-sql/)
- [Continuous Delivery for Azure SQL DB using Azure DevOps Multi-stage Pipelines](https://devblogs.microsoft.com/azure-sql/continuous-delivery-for-azure-sql-db-using-azure-devops-multi-stage-pipelines/)

- Videos resources
    - [Getting Started with DevOps for Azure SQL | Data Exposed](https://www.youtube.com/watch?v=j7OnxOz7YDY&t=0s)
    - []()
---

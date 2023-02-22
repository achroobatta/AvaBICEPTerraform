# Introduction 
This template will deploy an Azure SQL Managed Instance in a selected resource group.

- Azure SQL Managed Instance is the intelligent, scalable cloud database service that combines the broadest SQL Server database engine compatibility with all the benefits of a fully managed and evergreen platform as a service. SQL Managed Instance has near 100% compatibility with the latest SQL Server (Enterprise Edition) database engine, providing a native virtual network (VNet) implementation that addresses common security concerns, and a business model favorable for existing SQL Server customers. SQL Managed Instance allows existing SQL Server customers to lift and shift their on-premises applications to the cloud with minimal application and database changes. At the same time, SQL Managed Instance preserves all PaaS capabilities (automatic patching and version updates, automated backups, high availability) that drastically reduce management overhead and TCO.

- Azure SQL Managed Instance is designed for customers looking to migrate a large number of apps from an on-premises or IaaS, self-built, or ISV provided environment to a fully managed PaaS cloud environment, with as low a migration effort as possible.
# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | jenay.jeeva |

# Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |

# Module Dependencies
- NetworkSecurityGroups
- RouteTable


# Create resources using Azure cli and Azure Powershell commands 
- [See this document for creating the SQL single database via](https://docs.microsoft.com/en-us/azure/azure-sql/database/single-database-create-quickstart?view=azuresql&tabs=azure-powershell):
    ```
    - Portal
    - Azure CLI
    - Azure CLI (SQL Up)
    - PowerShell 
    ```


# Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| managedInstanceName | The name of the SQL Managed Instance | string |
| administratorLogin | The administrator username of the SQL logical server |  string |
| administratorLoginPassword | The administrator password of the SQL logical server |  string |
| serverName | The name of the SQL logical server |  string |
| skuName | The SKU name defining the capacity, family, size and tier of the Managed Instance | string |
| vCores | The quantity of virtual cores (logical CPUs) provisioned for the SQL Server - allowing for easy translation of on-premise workloads to the cloud | int |
| storageSizeInGB | The storage size in GB | int |
| licenseType | The license type for whether you need or have a license (and are elegible for the Azure Hybrid Benefit) | string | 
| location | Location to deploy resources |  string |
| nsgName | The name of the network security group of the subnet | string |
| routeTableName | The name of the routetable passed to the subnet | string |
| vnetName | The name of the virtual network for the resource | string |
| addressPrefix | The network address prefix for the virtual network | string |
| subnetName | The name of the subnet to delegate to the SQL Managed Instance | string |
| subnetPrefix | The subnet address prefix for the SQL Managed Instance delegated subnet | string |

# Optional/Advance Parameters
There are no advance or optional Parameters.

# References
- [Quickstart: Create an Azure SQL Managed Instance using an ARM template](https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/create-template-quickstart?view=azuresql&tabs=azure-powershell)
- [Microsoft.Sql managedInstances](https://docs.microsoft.com/en-us/azure/templates/microsoft.sql/managedinstances?pivots=deployment-language-arm-template)
- [Connectivity architecture for Azure SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/connectivity-architecture-overview?view=azuresql)
- [What is Azure SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/sql-managed-instance-paas-overview?view=azuresql)
- [Configure an existing virtual network for Azure SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/managed-instance/vnet-existing-add-subnet?view=azuresql)
- [vCore purchasing model overview - Azure SQL Database and Azure SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/database/service-tiers-vcore?view=azuresql)
- [Azure Hybrid Benefit - Azure SQL Database & SQL Managed Instance](https://docs.microsoft.com/en-us/azure/azure-sql/azure-hybrid-benefit?view=azuresql&tabs=azure-portal)
---

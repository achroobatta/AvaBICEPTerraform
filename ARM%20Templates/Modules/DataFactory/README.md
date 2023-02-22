# Introduction 
In the world of big data, raw, unorganized data is often stored in relational, non-relational, and other storage systems. However, on its own, raw data doesn't have the proper context or meaning to provide meaningful insights to analysts, data scientists, or business decision makers.

Big data requires a service that can orchestrate and operationalize processes to refine these enormous stores of raw data into actionable business insights. Azure Data Factory is a managed cloud service that's built for these complex hybrid extract-transform-load (ETL), extract-load-transform (ELT), and data integration projects.

Azure Data Factory is composed of below key components:
- **Pipelines** - 
A pipeline is a logical grouping of activities that performs a unit of work. Together, the activities in a pipeline perform a task.

- **Activities** - 
Activities represent a processing step in a pipeline.

- **Datasets** - 
Datasets represent data structures within the data stores, which simply point to or reference the data you want to use in your activities as inputs or outputs.

- **Linked services** - Linked services are much like connection strings, which define the connection information that's needed for Data Factory to connect to external resources.
- **Mapping Data Flows** - Create and manage graphs of data transformation logic that you can use to transform any-sized data. You can build-up a reusable library of data transformation routines and execute those processes in a scaled-out manner from your ADF pipelines.
- **Integration Runtimes** - An integration runtime provides the bridge between the activity and linked Services. It's referenced by the linked service or activity, and provides the compute environment where the activity either runs on or gets dispatched from. 

| Version | Date | Release Notes | Author |
|---|---|---|--|
| 1.0 | July22 | First release | jenay.jeeva |

# Module Dependencies
- N/A

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|
| dataFactoryName | The name of the data factory resource | string | 
| location | The location for deploying the data factory | string |

# Optional Parameters
| Parameter Name | Description | Type | 
There are no optional parameters. 

# References
- [Azure Data Factory](https://azure.microsoft.com/en-au/services/data-factory/)
- [Microsoft.DataFactory factories](https://docs.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories?pivots=deployment-language-arm-template)
- [What is Azure Data Factory?](https://docs.microsoft.com/en-au/azure/data-factory/introduction)
- [Quickstart: Create an Azure Data Factory using ARM template](https://docs.microsoft.com/en-au/azure/data-factory/quickstart-create-data-factory-resource-manager-template)
- [Copy data from Azure Blob storage to a SQL Database by using the Copy Data tool](https://docs.microsoft.com/en-au/azure/data-factory/tutorial-copy-data-tool)
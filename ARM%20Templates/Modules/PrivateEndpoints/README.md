# Introduction 
A private endpoint is a network interface that uses a private IP address from your virtual network. This network interface connects you privately and securely to a service that's powered by Azure Private Link. By enabling a private endpoint, you're bringing the service into your virtual network.

| Version | Date | Release Notes | Author |
|---|---|--|--|
| 1.0 | July22 | First release | jenay.jeeva |

# Module Dependencies
- VirtualNetwork
- Subnet
## Optional Dependencies (requires one selection)
- Azure SQL Server
- Key Vault
- Application Gateway
- Data Factory
- Storage Account

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|
| location | Location for all resources |  string |
| resourceSelection | Selection for which resource to create a private endpoint for | string | 
| resourceName | The name of the resource to create a private endpoint for | string | 
| subnetName | The subnet where the resource exists and for deploying the private endpoint | string |
| vnetName | The virtual network where the subnet exists | string |

# Optional Parameters
| Parameter Name | Description | Type | 
|--|--|--|
| storageSubresource | The sub-resource for when selecting to deploy a private endpoint for a storage account | string |

# References
- [What is a private endpoint?](https://docs.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
- [What is Azure Private Link?](https://docs.microsoft.com/en-us/azure/private-link/private-link-overview)
- [Use private endpoints for Azure Storage](https://docs.microsoft.com/en-us/azure/storage/common/storage-private-endpoints)
- [Storage account overview](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview?toc=%2Fazure%2Fstorage%2Fblobs%2Ftoc.json)
- [Quickstart: Create a private endpoint by using an ARM template](https://docs.microsoft.com/en-us/azure/private-link/create-private-endpoint-template)
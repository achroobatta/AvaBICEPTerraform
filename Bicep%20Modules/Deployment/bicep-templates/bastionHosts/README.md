# Introduction 
This template will deploy an Azure Bastion host.
## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release |  |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
| Vnet | Provision virtual network |  |
| Subnets | Provision subnets | |
| PublicIP | Public IP | |
| logAnalytics | log analytics workspace |  |
| storageAccount | storage account to store logs | |


## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| name | name of the bastion host | string |
| location | location of the resource | string |
| tags | tags for the resource | object | 
| sku | sku for the bastion host | string |
| vnetName | name of the virtual network | string |
| privateIPAllocationMethod | Private IP allocation method | string |
| scaleUnits | No.of scale units with which to provision the Bastion Host | number | 
| pip | Private IP name | string | 
| disableCopyPaste | Copy/Paste feature disabled for the Bastion Host ? | boolean | 
| enableFileCopy | Is File Copy feature enabled for the Bastion Host? | boolean | 
| enableIpConnect | Is Tunneling feature enabled for the Bastion Host | boolean | 
| enableShareableLink | Is Shareable Link feature enabled for the Bastion Host | boolean | 
| ipConfigurations | ip configurations | object | 

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

- What is Azure Bastion Host? https://docs.microsoft.com/en-us/azure/bastion/bastion-overview




## References
- [saikovvuri/azureSqlManagedInstance](https://github.com/saikovvuri/azureSqlManagedInstance/tree/main)
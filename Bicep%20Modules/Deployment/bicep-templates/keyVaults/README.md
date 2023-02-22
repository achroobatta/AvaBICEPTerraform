# Introduction 
This template will deploy an Azure Key Vault.
## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
| logAnalytics | Provision log analytics workspace |  |
| StorageAccount | Provision storage account | |


## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| name | name of the keyvault | string |
| sku | sku of the keyvault | string |
| publicNetworkaccess | public network access | string | 
| tags | tags for keyvault | object | 
| location | location of the keyvault | string | 
| createMode | create mode | string |
| enabledForDeployment | whether Azure Vms are permitted to retrieve certificates stored as secrets from the key vault | boolean |
| enabledForDiskEncryption | specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys | boolean |
| enabledForTemplateDeployment | Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault | boolean | 
| enablePurgeProtection | enable purge protection | boolean | 
| enableRbacAuthorization | enable RBAC authorization? | boolean |
| enableSoftDelete | enable soft delete | boolean |
| networkAcls | network rules | object | 
| softDeleteRetentionInDays | no.of days that items should be retained for once soft-deleted | number | 


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

- What is Azure Key Vault? https://docs.microsoft.com/en-us/azure/key-vault/general/basic-concepts

# Introduction 
This template deploys a storage account in your resource group.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August26 | First release | eashan.nakar |

# Module Dependencies
Create resourse group before deploying app service using:

| Azure CLI |
|---|
az group create --name demoResourceGroup --location westus

| Azure Powershell |
|---|
New-AzResourceGroup -Name exampleGroup -Location westus

# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|---|
| storageAccountObject | This object consists of the following parameters: sku, kind, identity (type), properties (accessTier, allowBlobPublicAccess, allowCrossTenantReplication, allowSharedKeyAccess, defaultToOAuthAuthentication, keyPolicy, minimumTlsVersion, networkAcls, publicNetworkAccess, routingPreference , supportsHttpsTrafficOnly) | object |
| tags | The key-value pair that is attached to the strage account | object |
| name | The name of the storage account | string |
| location | The location of the storage account | string |
| workspaceGroup | Params from the global.yml | string |
| hubSubscription | Params from the global.yml | string | 

# References
[An overview of Storage Accounts](https://docs.microsoft.com/en-us/azure/storage/common/storage-account-overview)
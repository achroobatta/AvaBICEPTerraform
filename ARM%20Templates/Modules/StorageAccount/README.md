# Introduction 
It deploys a storage account in your resource group

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | Vinita Bhasin |

# Module Dependencies
Create resourse group before deploying app service using:

| Azure CLI |
|---|
az group create --name demoResourceGroup --location westus

| Azure Powershell |
|---|
New-AzResourceGroup -Name exampleGroup -Location westus

# Required Parameters
| Parameter Name | Description | Type | Default value |
|---|---|---|---|
| storageAccountName | resource group name | string | 
| location | region | string | "[resourceGroup().location]" |
|
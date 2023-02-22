# Introduction 
It deploys the virtual network and their components like subnet, networkInterface and etc. 

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | Vinita Bhasin |

# Module Dependencies
Create resource group before deploying this resource using:

| Azure CLI |
|---|
az group create --name demoResourceGroup --location <region>

| Azure Powershell |
|---|
New-AzResourceGroup -Name exampleGroup -Location <region>

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|---|
| vnetName | name | string |
| location | region | string |


# Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

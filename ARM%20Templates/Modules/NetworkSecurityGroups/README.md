# Introduction 
It deploys the network security groups and its rules. 

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | Vinita Bhasin |

# Module Dependencies
1. Create resource group before deploying this resource using:

| Azure CLI |
|---|
az group create --name demoResourceGroup --location <region>

| Azure Powershell |
|---|
New-AzResourceGroup -Name exampleGroup -Location <region>

2. Virtual network should also be created. Use Module VirtualNetwork to create network and its components.


# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|---|
| nsgName | name | string |
| location | region | string |


# Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 
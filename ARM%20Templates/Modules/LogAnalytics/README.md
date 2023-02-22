# Introduction 
It deploys the log analytics workspace.

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
| workspaceName | log analytic workspace name | string |

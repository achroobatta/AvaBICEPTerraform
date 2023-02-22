# Introduction 
It deploys an App Service plan and an App Service app on Linux/Windows. It's compatible with all supported programming languages on App Service.
Two Azure resources are defined in the template:

Microsoft.Web/serverfarms: create an App Service plan.
Microsoft.Web/sites: create an App Service app.

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

# Required Parameters for linux 
| Parameter Name | Description | Type | Default value |
|---|---|---|---|
| webAppName | App name | string | na |
| location | App region | string | "[resourceGroup().location]" |
| sku | Instance size (F1 = Free Tier) | string | "F1" |
| linuxFxVersion | "Programming language stack and version" | string | "DOTNETCORE3.0" |

# Required Parameters for windows
| Parameter Name | Description | Type | Default value |
|---|---|---|---|
| webAppName | App name | string | na |
| location | App region | string | "[resourceGroup().location]" |
| sku | Instance size (F1 = Free Tier) | string | "F1" |
| language | Programming language stack (.NET, php, node, html) | string | ".net" |
| helloWorld | True = Deploy "Hello World" app | boolean | False |

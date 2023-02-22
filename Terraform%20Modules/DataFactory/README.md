# Introduction 
This module creates Azure Data Factory, Azure Data Factory Managed End Point and Azure Data Factory Pipeline.
Azure monitor onboarding module is imported to configure logs and metrics.
Provisioning data factory dataset, linked service and trigger is beyond the scope of this module. Please refer to the resource provider documentation to provision these resources.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | August22 | First release | santosh.manne |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
| Module Name | Description | Tested Version |
|---|---|---|
| AzureMonitor | Optional provisioning of required log analytics, event hub and storage account required for diagnostics logging | 1.0 |
| AzureMonitorOnboarding | Optional onboard and configure diagnostics to resources provisioned by AzureMonitor module | 1.1 |


# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| data_facroty_name | Name of the data factory | string |
| location | Location of the resource | string |
| resource_group_name | name of the resource group | string |
| tags | tags for the resource | map | 

# Optional Parameters
| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| managed_virtual_network_enabled | enable managed virtual network | false | boolean |
| public_network_enabled | is data factory visible to public networks? | false | boolean | 
| customer_managed_key_identiry_id | id of the user managed identity | null | string |
| github_configuration | configure github as data source | null | object({<br/>account_name = string<br/>branch_name = string<br/>git_url = string<br/>repository_name = string<br/>root_folder = string<br/>}) |
| global_parameter | global parameters | null | object({<br/>name = string<br/>type = string<br/>value = string<br/>}) | 
| managed_identity_type | type of managed identity | null | string |
| managed_identity_ids | list of user managed identity ids | null | list["string1", "string2"] | 
| vsts_configutation | vsts configuration | null | object({<br/>account_name = string<br/>branch_name = string<br/>project_name = string<br/>repository_name = string<br/>root_folder = string<br/>tenant_id = string<br/>}) | 
| private_endpoint_required | need a private endpoint? | false | string |
| private_endpoint_name | name of the private endpoint | null | string |
| target_resource_id | id of the target resource | null | string |
| subresource_name | subresource name | null | string |
| fqdns | list of fqdns | null | list["string1", "string2"] | 
| pipeline_required | enable pipeline? | false | string | 
| pipeline_name | name of the pilepline | null | string |
| pipeline_description | pipeline description | null | string |
| pipeline_annotations | annotations list | null | list["string1", "string2"] |
| pipeline_concurrency | no.of concurrent runs | null | number | 
| pipeline_folder | folder the pipeline is in | null | string | 
| pipeline_moniter_metrics_after_duration | time span after which the metrics are fired | null | number | 
| pipeline_parameters | map of parameters | null | map{"key" = "value"} | 
| pipeline_activities_json | json object of activities | null | string | 
| pipeline_Variables | variables map | null | map{"key" = "value"} | 
| logging_retention | retention period in days | 30 | number | 
| azure_monitor | azure monitor module output | null |  | 
# Outputs
| Parameter Name | Description | Type | 
|---|---|---|
| data_factory_id  | Data Factory id output | any | 
| endpoint_id | Private endpoint id output | any | 
| pipeline_id | Pipeline id output | any | 
# Reference
Azure Data factory: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory
Data Factory private endpoint: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_managed_private_endpoint
Data Factory pipeline: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_pipeline
# Additional details
## Sample usage when using this module in your own modules
```
module "policy" {
  source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules/DataFactory"
  data_factory_name = "avasandf1234"
  location = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags = {
    environment = "sandbox"
  }
}

```
## Sample usage when creating a private endpoint and pipeline
```
module "policy" {
  source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules/DataFactory"
  data_factory_name = "avasandf1234"
  location = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags = {
    environment = "sandbox"
  }
  pipeline_required = true 
  pipeline_name = "avasanpipe123"
  pipeline_variables = {
      "bob" = "item1"
    }
  pipeline_activities_json = <<JSON
  [
    {
        "name": "Append variable1",
        "type": "AppendVariable",
        "dependsOn": [],
        "userProperties": [],
        "typeProperties": {
            "variableName": "bob",
            "value": "something"
        }
    }
  ]
  JSON
  private_endpoint_required = true
  private_endpoint_name = "demoendpoint"
  target_resource_id = module.sa.sa_out.id
  subresource_name   = "blob"
}
resource "azurerm_resource_group" "avatest" {
  name     = "avatest"
  location = "Australia East"
}
module "sa" {
  source              = "./StorageAccount"
  name                = "someteststorage123"
  location            = "Australia East"
  storage_account_kind = "BlobStorage"
  resource_group_name = azurerm_resource_group.avatest.name
  tags = {
    environment = "sandbox"
  }
}

```
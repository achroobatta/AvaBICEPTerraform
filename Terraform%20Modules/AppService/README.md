# Introduction 
Creation of an App service plan is provisioned in this module.
Creation of App Service Environment is also provisioned in this module. This is an optional feature and is used to provides a fully isolated and dedicated environment for running App Service apps securely at high scale.
Provisioning vnets, subnets, storage accounts is not included in this module.
Provisioning Windows and Linux web app and app slots are also included in this module. These are made optional and the user can choose to provision them.

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
| AzureMonitor | Required provisioning of required log analytics, event hub and storage account required for diagnostics logging | 1.0 |
| AzureMonitorOnboarding | Optional onboard and configure diagnostics to resources provisioned by AzureMonitor module | 1.1 |
| AzureKeyVault | Required provisioning for storing passwords securely | 1.0 |
| VirtualNetwork | Required to create vnet, subnets, nsgs, network security rules | 1.0 |
|  

# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| app_service_name | Name of the app service | string |
| resource_group_name | RG name | string |
| location | Location of the resources | string |
| os_type | type of os | string |
| sku_name | required sku for the plan | string |
| tags | tags required | map |


# Optional/Advance Parameters

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| appse_name | App service environment name | null | string | 
| subnet_id | Azure subnet module output | null | string |
| linux_web_app_name | Name of the web app | null | string |
| linux_tags | tags for the web app | null | map |
| site_config | site configuration for web app | {} | any |
| linux_web_app_slot_name | Slot name to be provisioned | null | string |
| app_service_environment_id | ID of the environment | null | string |
| maxumum_elastic_worker_count | worker count | null | number | 
| worker_count | No.of workers required | null | number |
| per_site_scaling_enabled | enabled? | false | boolean| 
| zone_balancing_enabled | enabled? | false | boolean | 
| pricing_tier | Pricing tier for the front end instances | I1 | string |
| front_end_scale_factor | scale factor | 15 | number |
| internal_load_balancing_mode |  which endpoints to serve internally | null | string |
| allowed_user_ip_cidrs | Allowed user added IP ranges | null | list["string1", "string2"] |
| cluster_setting | store App Service Environment customizations | null | object({<br/>name = string<br/>value = number<br/>}) |
| https_only | disable http protocol? | true | boolean |
| app_setting | App application settings | {} | map(any) |
| client_certificate_mode | client certificate | Optional | string |
| client certificate enabled | enable? | false | boolean |
| zip_deploy_file | local path and file name of the zipped application | null | string |
| enabled | should linux web app be enabled | true | boolean |
| storage_uses_managed_identity | do you want managed identity for storage account | false | boolean |
| identity_ids | list of user managed ids | [] | list["string1", "string2"] |
| identity_type | Manaaged service identity type | "" | string |
| storage account | storage account patrameters | null | object({<br/>access_key = string<br/>account_name = string<br/>name = string<br/>share_name = string<br/>type = string<br/>mount_path = string<br/>}) |
| active_directory_auth_settings | AD authentication | {} | any | 
| backup_sas_url | URL SAS to backup | null | string |
| builtin_logging_enabled | AzureWebJobsDashboards should be enabled? | true | boolean |
| connection_strings | Connection strings for App Service | null | list(map(string)) |
| auto_swap_slot_name | slot name to automatically swap | null | string |
| appse_required | enable app service environment? | false | string |
| linux_web_app_required | enable linux web app? | false | string |
| linux_web_app_slot_required | enable linux app slot? false | string |
| windows_web_app_required | enable windows web app? | false | string | 
| windows_web_app_slot_required | enable windows app slot? | false | string |

# Outputs
| Parameter Name | Description | Type | 
|---|---|---|
| app_service_plan | Output of app service plan | any |
| app_service_environment | Output of app service environment | any |
| linux_app | Output of Linux web app | any |

# Reference
App service plan: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan
App service environment: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_environment
linux web app: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app
linux web app slot: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app_slot
Windows web app: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app
Windows web app slot: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_web_app_slot

# Additional details
## Sample basic usage 
```
resource "azurerm_resource_group" "avatest" {
  name     = "avatest"
  location = "Australia East"
}

module "app_service_plan" {
source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules/AppService/"
app_service_name = "avaappservice"
resource_group_name = azurerm_resource_group.avatest.name
location = "Australia East"
tags = {
    environment = "sandbox"
  }
os_type = "Linux"
sku_name = "P1v2"
settings = {
    site_config = {
      minimum_tls_version = "1.2"
      http2_enabled       = true

      application_stack = {
        python_version = 3.9
      }
    }

    auth_settings = {
      enabled = true
    }
  }
}
```

## Sample usage with additional parameters and provisioning linux web app and slot
```
module "app_service_plan" {
source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules/AppService/"
app_service_name = "avaappservice"
resource_group_name = azurerm_resource_group.avatest.name
location = "Australia East"
tags = {
    environment = "sandbox"
  }
os_type = "Linux"
sku_name = "P1v2"
settings = {
    site_config = {
      minimum_tls_version = "1.2"
      http2_enabled       = true

      application_stack = {
        python_version = 3.9
      }
    }

    auth_settings = {
      enabled = true
    }
  }
appse_name = "testappserviceenvironment"
subnet_id = module.vnet,subnets_out[0].id
linux_web_app_required = true
linux_web_app_slot_required = true
linux_webb_app_name = "avasanwebapp123"
linux_web_app_slot_name = "staging"
linux_tags = {
    environment = "sandbox"
  }
}
module "vnet" {
  source = "./VirtualNetwork/"
  virtual_network_name = "myvnet"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  address_space = ["10.0.0.0/16"]
  subnet_definition = [{
    name = "subnetI"
    prefix = ["10.0.1.0/24"]
    service_endpoints = []
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = false
    delegations = []
  }]
  tags = {
    environment = "sandbox"
  }

```
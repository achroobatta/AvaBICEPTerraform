# Introduction 
Provisions AKV with default access provided to account used by Terraform.
Creation of keys, secrets and certificates are called using their respective resource providers.
Default access policy granting full access to the account running the terraform configuration while additional Access Policy can be added by calling the "azurerm_key_vault_access_policy" resource provider.
Contacts cannot be created until the subsequent runs due to the use of "azurerm_key_vault_access_policy" resource provider, attempting to do so will result in permission issues.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.1 | Oct22 | Fixed SKU_name optional requirement | Viktor.Lee |
| 1.0 | July22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.1 | 1.3.3 | 3.28.0 |
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
| Module Name | Description | Tested Version |
|---|---|---|
| AzureMonitor | Optional provisioning of required log analytics, event hub and storage account required for diagnostics logging | 1.0 |
| AzureMonitorOnboarding | Optional onboard and configure diagnostics to resources provisioned by AzureMonitor module | 1.1 |

# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| name | Name of the AKV | string |
| location | Azure region of where to provision the AKV | string |
| resource_group_name | Name of the RG | string |
| tags | Azure Tags | map |
| sku_name | sku name of AKV | string |



# Optional/Advance Parameters
Reference for AKV resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault

Reference for AKV access policy resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy


| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor| The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| sku_name | sku name of AKV | "standard" | string |
| enabled_for_deployment | refer to resource provider for usage | false | bool |
| enabled_for_disk_encryption | refer to resource provider for usage | false | bool |
| enabled_for_template_deployment | refer to resource provider for usage | false | bool |
| enable_rbac_authorization | refer to resource provider for usage | false | bool |
| soft_delete_retention_days | refer to resource provider for usage | 7 | number |
| purge_protection_enabled | refer to resource provider for usage | false | bool |
| purge_soft_delete_on_destroy | purge_soft_delete_on_destroy enabled or disabled | true | bool |
| network_acls | Enter value required by network_acl block, refer to resource provider for usage | null | object({<br/>bypass = string<br/>default_action = string<br/>ip_rules = list(string)<br/>virtual_network_subnet_ids = list(string)<br/>}) |
| contacts | Enter value required by network_acl block, refer to resource provider for usage. Requires permission to AKV to set. | [] | list(object({<br/>email = string<br/>name  = string<br/>phone = string<br/>})) |


# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| akv_out | Output of AKV object | any |
| akvap_out | Output of the AKV access policy object granting access to terraform account | any |

# Additional details
## Simple code sample
```
module "akv" {
  source  = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//KeyVault"
  name  = "avatestakv"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  azure_monitor = module.azure_monitor/*
  contacts = [{
    email = "v@v.com"
    name = null
    phone = "9999"
  }]
  network_acls = {
    bypass = "AzureServices"
    default_action = "Deny"
    ip_rules= ["11.0.0.0/8"]
    virtual_network_subnet_ids=[]
  }
  */
}
```
## Sample creation of additional AKV access policies
```
resource "azurerm_key_vault_access_policy" "policy2" {
  key_vault_id = module.akv.akv_out.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = "40f505ee-5954-4fbf-b3f8-9928e5b040e5"

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List",
    ]

    storage_permissions = [
      "Get",
    ]
}
```
## Sample creation of secret
Use the same process for other types of resources but reference their respective resource provider (e.g. certificates, keys).
Depends_on code block ensures these resources residing in AKV is cleaned up before access policies are removed.

Note: Your terraform or pipeline must have access/connectivity to access/modify these resources in the AKV before the activity can be performed.
```
resource "azurerm_key_vault_secret" "akv_secret" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = module.akv.akv_out.id
  depends_on = [
    module.akv
  ]
}
```
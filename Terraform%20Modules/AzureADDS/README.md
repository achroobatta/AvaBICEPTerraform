# Introduction 
Create Azure ADDS and its supporting components: NSG rules, admin user, admin group and application registration

Option to create randomly generated complex password and store it securely in a AKV.

Azure ADDS is not compatible with whitelisting enforced NSG rules created by the Virtual Network module, use the resource providers directly to create the subnet and NSG.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | Aug22 | First release | viktor.lee |

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
| name | Name of the resources | string |
| location | Location of the resources | string |
| resource_group_name | Name of the RG | string |
| tags | Azure Tags | map |
| network_security_group_names | NSG name that the AADDS is affected by, pass output of the NSG resource provider instead of string for implicit dependency | string |
| admin_upn | userprincipalname of the admin user to be created | string |
| domain_name | domain name of aadds | string |
| subnet_id | subnet_id to attach the aadds | string |
| use_random_password | Option for the module to generate random complex password and store it in AKV | bool |

# Optional/Advance Parameters
Reference for Azure ADDS resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/active_directory_domain_service

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor| The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| logging_retention | Retention period of diagnostics configuration  | 30 | number |
| password_akv_id | Required when relying on random generated password, AKV ID to be used with VM to store the password| null | string |
| password_akv_access_policy | Required when relying on random generated password, Set dependency on the akv access policy used to manage the password | null | string |
| admin_password | define the admin user password to be created. Random complex password will be generated if left empty | null | string |
| sku | refer to active_directory_domain)service for usage | "Standard" | string |
| filtered_sync_enabled | refer to active_directory_domain)service for usage | false | bool |
| notifications | notifications block, refer to active_directory_domain_service for usage | null | object({<br/>additional_recipients = list(string)<br/>notify_dc_admins      = bool<br/>notify_global_admins  = bool<br/>}) |
| secure_ldap | secure_ldap block, refer to active_directory_domain)service for usage. A sensitive variable. Sensitive variable | null | object({<br/>enabled = bool<br/>external_access_enabled = bool<br/>pfx_certificate = any<br/>pfx_certificate_password = any<br/>}) |
| security | security block, refer to active_directory_domain)service for usage. A sensitive variable | null | object({<br/>sync_kerberos_passwords = bool<br/>sync_ntlm_passwords     = bool<br/>sync_on_prem_passwords  = bool<br/>ntlm_v1_enabled = bool<br/>tls_v1_enabled = bool<br/>}) |



# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| aadds_out | Output of the Azure ADDS | any |
| adminuser_out | Output of the AAD DS admin user created by this module | any |
| dcadmins_out | Output of the dc admin group created by this module | any |
| aaddsspn_out | Output of the AAD DS SPN created by this module | any |


# Additional details
## Simple code sample
```
module "aadds" {
  source                       = "./AzureADDS"
  name         = "aadds"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  admin_upn = "aaddsadmin@ljweimagehotmail.onmicrosoft.com"
  domain_name = "ljweimagehotmail.onmicrosoft.com"
  network_security_group_names = [azurerm_network_security_group.AADDSnsg.name]
  subnet_id = azurerm_subnet.AzureADDS.id
  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
  azure_monitor = module.azure_monitor
}
```

## Code to provision separate subnet and NSG into a VNET created by the module
```
resource "azurerm_subnet" "AzureADDS" {
  name                 = "AzureADDS"
  virtual_network_name = module.vnetmodule.vnet_out.name
  resource_group_name  = azurerm_resource_group.avatest.name
  address_prefixes       = ["10.0.5.0/24"]
  depends_on = [
    module.vnetmodule
  ]
}

resource "azurerm_network_security_group" "AADDSnsg" {
  name                = "AADDS_NSG"
  resource_group_name = azurerm_resource_group.avatest.name
  location            = "Australia East"
}


resource "azurerm_subnet_network_security_group_association" "aadds" {
  subnet_id                 = azurerm_subnet.AzureADDS.id
  network_security_group_id = azurerm_network_security_group.AADDSnsg.id
}
```
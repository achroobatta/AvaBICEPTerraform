# Introduction 
Provision Windows VM, OS and data disks, and NICs.
This module is not meant to provision scale sets or Linux.
NSGs are assumed to be managed on the subnet level.
WinRm is optional and always enabled to https.
Due to the huge permutations of options and dependencies available for VM diagnostics/logging, it will be left to the user to create their own extensions and json configurations via the "azurerm_virtual_machine_extension" resource provider.

Option to create randomly generated complex password and store it securely in a AKV.

Only basic options are exposed for creating empty data disks to reduce module complexity, call the respective resource provider to create and attach advanced settings data disks if required (e.g. data disk based on images or in different availability zones, if you want disks with different encryption options from each other).
Take note that some parameters defined for the VM and OS disk is automatically applied to the data disks as well, review the parameters section for further information.
Secure_vm_disk_encryption_set_id are not exposed to the data disks due to requirements for the disk image to be set to 'FromImage' or 'Import'

Due to limitation of the resource provider, removal of additional NICs after they have been provisioned has to be manually deassociated from the VM (which also involve manually shutting down the VM as part of Azure requirments) before executing the terraform code.
Due to limitation of resource provider behavior after a VM is restored from a backup, use the vmrestored parameter to bring the data disks out of Terraform state management.
There is a known bug in Azure resource provider when attaching disks within and outside the module at the same time, running the terraform apply twice will resolve the issue.


# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | viktor.lee |

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
| name | Name of the VM | string |
| location | Azure region of where to provision the VM | string |
| resource_group_name | Name of the RG | string |
| size | Size of the vm | string |
| tags | Azure Tags | map |
| vm_nics | vm nics configuration list | list(object({<br/>subnet_id=string<br/>public_ip_address_id=string<br/>private_ip_address=string<br/>private_ip_address_version=string<br/>})) |
| use_random_password | Option for the module to generate random complex password and store it in AKV | bool |


# Optional/Advance Parameters
Reference for Windows VM resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine

Reference for Managed disk resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk

Reference for attaching managed disk to VM resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment


| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor | The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| logging_retention | Retention period of diagnostics configuration  | 30 | number |
| password_akv_id | Required when relying on random generated password, AKV ID to be used with VM to store the password| null | string |
| password_akv_access_policy | Required when relying on random generated password, Set dependency on the akv access policy used to manage the password | null | string |
| vmrestored | Have this VM been restore? | false | bool |
| data_disks | Data disks to create and attach | [] | list(object({<br/>name=string<br/>size=string<br/>})) |
| admin_username | admin_username | "winadmin" | string<br/>senstive |
| admin_password | define the admin user password to be created. Random complex password will be generated if left empty | null | string<br/>senstive |
| license_type | refer to VM resource provider for usage | null | string |
| vtpm_enabled | refer to VM resource provider for usage | null | bool |
| secure_boot_enabled | refer to VM resource provider for usage | null | bool |
| encryption_at_host_enabled | refer to VM resource provider for usage | null | bool |
| availability_set_id | refer to VM resource provider for usage | null | string |
| zone | refer to VM resource provider for usage, also applied to the data disk | null | string |
| dedicated_host_id | refer to VM resource provider for usage | null | string |
| dedicated_host_group_id | refer to VM resource provider for usage | null | string |
| proximity_placement_group_id | refer to VM resource provider for usage | null | string |
| edge_zone | refer to VM resource provider for usage, also applied to the data disk and VNIC | null | string |
| capacity_reservation_group_id | refer to VM resource provider for usage | null | string |
| provision_vm_agent | refer to VM resource provider for usage | true | bool |
| enable_automatic_updates | refer to VM resource provider for usage | true | bool |
| hotpatching_enabled | refer to VM resource provider for usage | false | bool |
| patch_mode | refer to VM resource provider for usage | null | string |
| allow_extensions_operations | refer to VM resource provider for usage | null | bool |
| extensions_time_budget | refer to VM resource provider for usage | "PT1H30M" | string |
| eviction_policy | refer to VM resource provider for usage | null | string |
| max_bid_price | refer to VM resource provider for usage | null | number |
| termination_notification_timeout | refer to VM resource provider for usage for timeout parameter in termination_notification block | null | number |
| winrm_listener_certificate_url | refer to VM resource provider for usage for certificate_url parameter in winrm_listener block | null | string |
| secret_key_vault_id | refer to VM resource provider for usage for vault_id parameter in secret block | null | string |
| certificates | refer to VM resource provider for usage for certificate block | null | list(object({<br/>store = string<br/>url = string<br/>})) |
| priority | refer to VM resource provider for usage | null | string |
| source_image_reference| Source Image Reference, cannot be used together with source_image_id, but at least one must be defined | {<br/>offer     = null<br/>publisher = null<br/>sku       = null<br/>version   = null<br/>} | object({<br/>offer     = string<br/>publisher = string<br/>sku       = string<br/>version   = string<br/>}) |
| source_image_id | Source Image id, cannot be used together with source_image_reference, but at least one must be defined | null | string |
| plan | plan block | {<br/>name     = null<br/>product = null    <br/>publisher = null<br/>} | object({<br/>name     = string<br/>product = string<br/>publisher = string<br/>}) |
| identity | identity block | {<br/>type = null<br/>identity_ids = null<br/>} | object({<br/>type = string<br/>identity_ids = list(string)<br/>}) |
| ultra_ssd_enabled | enable ultra_ssd | false | bool |
| os_disk | os_disk. disk_encryption_set_id will also be applied to the data disk. | {<br/>caching           = "ReadWrite"<br/>storage_account_type = "Standard_LRS"<br/>disk_size_gb = null<br/>write_accelerator_enabled = null<br/>disk_encryption_set_id = null<br/>security_encryption_type = null<br/>secure_vm_disk_encryption_set_id = null<br/>diff_disk_settings = {<br/>option = null<br/>placement = null<br/>}<br/>} | object({<br/>caching           = string<br/>storage_account_type = string<br/>disk_size_gb = string<br/>write_accelerator_enabled = string<br/>disk_encryption_set_id = string<br/>security_encryption_type = string<br/>secure_vm_disk_encryption_set_id = string<br/>diff_disk_settings = object({<br/>option = string<br/>placement = string<br/>})<br/>})|
| additional_unattend_content | additional_unattend_content block | {<br/>content = null<br/>setting = null<br/>} | object({<br/>content = any<br/>setting = string<br/>}) |


# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| vm_out | Output of vm object | any |
| vm_nics_out | Output of vm NIC object(s) | any |
| vm_disks_out | Output of vm data disk object(s) | any |

# Additional details
## Simple code sample with in module data disk creation
```
module "winvm" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VirtualMachineWindows/"
  name  = "avatestwin"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  size = "Standard_A2_v2"
  use_random_password = true
  tags         = {
    environment = "sandbox"
  }
  azure_monitor = module.azure_monitor
  data_disks=[{
    name="D"
    size="10"
  }
  ]
  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
  vm_nics = [
    {
    subnet_id = module.vnetmodule.subnets_out[0].id
    private_ip_address = "10.0.0.10"
    private_ip_address_version= "IPv4"
    public_ip_address_id = azurerm_public_ip.publicip.id
    }
  ]
  source_image_reference= {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}
```
## Sample code to attach data disks not created by the module
```
resource "azurerm_managed_disk" "externaldisk" {
  name="externaldisk"
  location             = "Australia East"
  resource_group_name  = azurerm_resource_group.avatest.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"
  tags     = var.tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "externaldisksattach" {
  managed_disk_id    = azurerm_managed_disk.externaldisk.id
  virtual_machine_id = module.winvm.vm_out.id
  lun                = 50
  caching            = "ReadWrite"
}
```
## Sample code to use Customer Managed Keys in AKV
Note that this encryption configuration will be applied across OS disk and all data disks managed by this module. Create the data disks outside of the mdodule via resource provider directly if you want your disks to have different encryption settings from each other.
```
module "winvm" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VirtualMachineWindows/"
  name  = "avatestwin"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  size = "Standard_A2_v2"
  use_random_password = true
  tags         = {
    environment = "sandbox"
  }
  azure_monitor = module.azure_monitor
  data_disks=[{
    name="D"
    size="10"
  }
  ]
  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
  vm_nics = [
    {
    subnet_id = module.vnetmodule.subnets_out[0].id
    private_ip_address = "10.0.0.10"
    private_ip_address_version= "IPv4"
    public_ip_address_id = azurerm_public_ip.publicip.id
    }
  ]
  source_image_reference= {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk={
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = null
    write_accelerator_enabled = null
    disk_encryption_set_id = azurerm_disk_encryption_set.diskencrypt.id
    security_encryption_type = null
    secure_vm_disk_encryption_set_id = null
    diff_disk_settings = {
      option = null
      placement = null
    }
  }
}

resource "azurerm_key_vault_key" "akvkey" {
  name         = "des-example-key"
  key_vault_id = module.akv.akv_out.id
  key_type     = "RSA"
  key_size     = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}


resource "azurerm_disk_encryption_set" "diskencrypt" {
  name                = "des"
  resource_group_name = azurerm_resource_group.avatest.name
  location            = "Australia East"
  key_vault_key_id    = azurerm_key_vault_key.akvkey.id

  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_role_assignment" "diskencryptaccess" {
  scope                = module.akv.akv_out.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.diskencrypt.identity.0.principal_id
}

resource "azurerm_key_vault_access_policy" "diskencryptpolicy" {
  key_vault_id = module.akv.akv_out.id

  tenant_id = azurerm_disk_encryption_set.diskencrypt.identity.0.tenant_id
  object_id = azurerm_disk_encryption_set.diskencrypt.identity.0.principal_id

  key_permissions = [
    "Create",
    "Delete",
    "Get",
    "Purge",
    "Recover",
    "Update",
    "List",
    "Decrypt",
    "Sign",
    "WrapKey",
    "UnwrapKey",
  ]
}
```
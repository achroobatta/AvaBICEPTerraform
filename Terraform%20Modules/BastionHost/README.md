# Introduction 
Provision the Azure Bastion Host.

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
| name | Name of the Bastion | string |
| location | Azure region of where to provision the Bastion | string |
| resource_group_name | Name of the RG | string |
| tags | Azure Tags | map |
| sku | sku name of Bastion | string |
| ip_configuration | ip_configurations block, only one is required | list(object({<br/>name = string<br/>subnet_id  = string<br/>public_ip_address_id = string<br/>})) |


# Optional/Advance Parameters
Reference for Bastion resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/bastion_host


| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor| The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| logging_retention | Retention period of azure_monitor configuration | 30 | number |
| copy_paste_enabled | Refer to resource provier for usage  | null | bool |
| file_copy_enabled | Refer to resource provier for usage | null | bool |
| ip_connect_enabled | Refer to resource provier for usage | null | bool |
| shareable_link_enabled | Refer to resource provier for usage | null | bool |
| tunneling_enabled | Refer to resource provier for usage | null | bool |
| scale_units | Refer to resource provier for usage | null | number |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| bastion_out | Output of Bastion object | any |

# Additional details
## Simple code sample
```
module "bastion" {
  source  = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//BastionHost"
  name  = "avatest"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  sku = "Basic"
  azure_monitor = module.azure_monitor
  tags         = {
    environment = "sandbox"
  }
  ip_configuration={
    name= "ipconfig"
    subnet_id =azurerm_subnet.AzureBastionSubnetsubnet.id
    public_ip_address_id = azurerm_public_ip.publicip2.id
  }
}
```
## Create subnet required by Bastion separately while leveraging on Virtual Network Module
```
resource "azurerm_subnet" "AzureBastionSubnetsubnet" {
  name                 = "AzureBastionSubnet"
  virtual_network_name = module.vnetmodule.vnet_out.name
  resource_group_name  = azurerm_resource_group.avatest.name
  address_prefixes       = ["10.0.4.0/24"]
  depends_on = [
    module.vnetmodule
  ]
}
```
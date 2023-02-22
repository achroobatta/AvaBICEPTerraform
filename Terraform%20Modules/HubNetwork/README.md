# Introduction 
Create a VWAN and Hub. You can attach other components like Azure Firewall or VPN Gateways via our modules or directly via resource providers.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
There are no dependencies

| Module Name | Description | Tested Version |
|---|---|---|


# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| name | Name of the resources | string |
| location | Location of the resources | string |
| resource_group_name | Name of the RG | string |
| tags | Azure Tags | map |
| wan_type | type of the VWAN | string |
| hub_sku | sku of the hub | string |
| hub_address_prefix | hub address prefix | string |


# Optional/Advance Parameters
Reference for VWAN resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_wan
Reference for Hub resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_hub

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| disable_vpn_encryption | Refer to vwan resource provider for usage | null | bool |
| allow_branch_to_branch_traffic | Refer to vwan resource provider for usage | null | bool |
| office365_local_breakout_category | Refer to vwan resource provider for usage | null | bool |
| routes | Route block in hub resource. Refer to hub resource provider for usage | null | list(object({<br/>address_prefixes = list(string)<br/>next_hop_ip_address = string<br/>})) |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| wan_out | Output of the VWAN object | any |
| hub_out | Output of the hub object | any |

# Additional details
## Simple code sample
```
module "hub" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//HubNetwork"
  name         = "avatesthub"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  hub_address_prefix = "11.0.100.0/24"
  wan_type = "Basic"
  hub_sku = "Basic"
  tags         = {
    environment = "sandbox"
  }
  azure_monitor = module.azure_monitor
}
```
## Sample creation of Firewall to the hub
```
module "afw" {
  source  = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//AzureFirewall"
  name  = "avatestafw"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  sku_name = "AZFW_Hub"
  sku_tier = "Standard"
  dns_servers = [ "10.0.0.1" ]
  azure_monitor = module.azure_monitor
  tags         = {
    environment = "sandbox"
  }
  virtual_hub = {
    public_ip_count = 1
    virtual_hub_id = module.hub.hub_out.id
  }
}
```

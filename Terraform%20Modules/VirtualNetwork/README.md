# Introduction 
Provision Azure Virtual Network and Subnet(s) for non-hub networks, use the HubNetwork module to provision hub networks.
Each subnet is enforced to have its own NSG that has default deny all rules for whitelisting. 
Optional Network Flow configuration and diagnostics settings to Azure Monitor.
Mapping provided delegation type to list of permissible actions.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.3 | Dec22 | Added default NSG output to Azure Monitor at 80,443 | viktor.lee |
| 1.2 | Nov22 | Fix issue during failed destory where terraform index is broken during subsequent runs | viktor.lee |
| 1.1 | Oct22 | Updated for private_link_service_network_policies_enabled and private_endpoint_network_policies_enabled change by the resource provider | viktor.lee |
| 1.0 | July22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.3 | 1.3.6 | 3.34.0 |
| 1.2 | 1.3.4 | 3.30.0 |
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
| virtual_network_name | Name of the virtual network | string |
| location | Azure region of where to provision the virtual network | string |
| resource_group_name | Name of the virtual network | string |
| tags | Azure Tags | map |
| subnet_definition | define the number of subnets and its name and prefix | list(object({<br/>name= string<br/>prefix = list(string)<br/>service_endpoints = list(string)<br/>enforce_private_link_endpoint_network_policies = bool<br/>enforce_private_link_service_network_policies = bool<br/>delegations = list(string)<br/>})) |


# Optional/Advance Parameters
Reference for virtual network resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

Reference for subnet resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor| The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| ddos_protection_plan_id | DDOS Protection Plan resource ID <br/>No DDOS protection will be configured if left null  | null | string |
| dns_servers | Define any bespoke DNS servers to be pointed to  | null | list(string) |
| logging_retention | Retention period of diagnostics configuration  | 30 | number |
| network_watcher_name | Network watcher name to attach to <br/>No network watcher will be configured if left as null  | null | string |
| network_watcher_resource_group_name | Resoruce group that network watcher is residing in <br/>Value used only when network_watcher_name is not null | null | string |
| network_watcher_retention| Network watcher retention period <br/>Value used only when network_watcher_name is not null | 7 | number |
| bgp_community | Refer to azurerm_virtual_network provider for usage | null | string |
| edge_zone | Refer to azurerm_virtual_network provider for usage | null | string |
| flow_timeout_in_minutes | Refer to azurerm_virtual_network provider for usage | null | number |


# Outputs
| Parameter Name | Description | Type | 
|---|---|---|
| vnet_out | Output of the vnet object | any |
| subnets_out | Output of the subnet objects | any |
| nsg_out | Output of the nsg objects | any |

# Additional details
## Sample basic code
```
module "vnetmodule" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VirtualNetwork/"
  virtual_network_name         = "avavnet"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  address_space = ["10.0.0.0/16"]
  subnet_definition = [{
    name = "subnetI"
    prefix = ["10.0.0.0/24"]
    service_endpoints = []
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = false
    delegations = []
  },{
    name = "subnetII"
    prefix = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Sql","Microsoft.AzureActiveDirectory"]
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = false
    delegations = ["Microsoft.Sql/managedInstances"]
  }]
  tags         = {
    environment = "sandbox"
  }
  #dns_servers   = ["10.0.0.4"]
  #azure_monitor = module.azure_monitor
  #network_watcher_name = "NetworkWatcher_australiaeast"
  #network_watcher_resource_group_name = "NetworkWatcherRG"
  #ddos_protection_plan_id = azurerm_network_ddos_protection_plan.ddos.id
}
```
## Adding additional NSG rules
Use default resource provider to create additional NSG rules.
Either use depends_on code block or adding the output of the nsg name into var.network_security_group_name to allow Terraform to wait for VNET module to complete provisioning before applying your custom NSG rules.

Sample: 
```
resource "azurerm_network_security_rule" "testRule" {
  name                        = "testRule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.avatest.name
  network_security_group_name = module.vnetmodule.nsgs_out[0].name
  depends_on = [
    module.vnetmodule
  ]
}
```

## Subnet Delegation and actions
Subnet delegation actions are retrieved from a map within locals.tf based on your input for delegation type/names
Refer to locals.tf or terraform azurerm_subnet resource provider for permitted values for delegation type/names: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

local.tf will need to be updated should the list of permitted delegation and/or their respective action changes
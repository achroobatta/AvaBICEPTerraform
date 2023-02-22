# Introduction 
Provision the Azure Firewall and its diagnostics settigs to Azure Monitor.

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
| name | Name of the AZFW | string |
| location | Azure region of where to provision the AZFW | string |
| resource_group_name | Name of the RG | string |
| tags | Azure Tags | map |
| sku_name | sku name of AZFW | string |
| sku_tier | sku tier name of AZFW | string |



# Optional/Advance Parameters
Reference for AFW resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/firewall

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor| The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| logging_retention | Retention period of azure_monitor configuration | 30 | number |
| ip_configurations | ip_configurations block. Only one subnet_id can be populated, the others have to be null | null | list(object({<br/>name = string<br/>subnet_id  = string<br/>public_ip_address_id = string<br/>})) |
| firewall_policy_id | Refer to resource provider for usage | null | string |
| dns_servers | Refer to resource provider for usage | null | list(string) |
| private_ip_ranges | Refer to resource provider for usage | null | list(string) |
| threat_intel_mode | Refer to resource provider for usage | null | string |
| zones | Refer to resource provider for usage | null | list(string) |
| virtual_hub | virtual_hub block | null | object({<br/>virtual_hub_id = string<br/>public_ip_count = number<br/>}) |
| management_ip_configuration | management_ip_configuration block | null | object({<br/>name = string<br/>subnet_id = string<br/>public_ip_address_id = string<br/>}) |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| azfw_out | Output of AZFW object | any |

# Additional details
## Simple code sample to attach Azure Firewall on VNET
```
module "afw" {
  source  = "./AzureFirewall"
  name  = "avatestafw"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  sku_name = "AZFW_VNet"
  sku_tier = "Standard"
  dns_servers = [ "10.0.0.1" ]
  azure_monitor = module.azure_monitor
  tags         = {
    environment = "sandbox"
  }
  ip_configurations=[{
    name= "ipconfig"
    subnet_id =azurerm_subnet.azfwsubnet.id
    public_ip_address_id = azurerm_public_ip.publicip.id
  }]
}
```
## Simple code sample to attach Azure Firewall on VWAN Hub
```
module "afw" {
  source  = "./AzureFirewall"
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
## Create subnet required by Azure Firewall separately while leveraging on Virtual Network Module
```
resource "azurerm_subnet" "azfwsubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = module.vnetmodule.vnet_out.name
  resource_group_name  = azurerm_resource_group.avatest.name
  address_prefixes       = ["10.0.2.0/24"]
  depends_on = [
    module.vnetmodule
  ]
}

resource "azurerm_subnet" "azfwmanagementsubnet" {
  name                 = "AzureFirewallManagementSubnet"
  virtual_network_name = module.vnetmodule.vnet_out.name
  resource_group_name  = azurerm_resource_group.avatest.name
  address_prefixes       = ["10.0.3.0/24"]
  depends_on = [
    module.vnetmodule
  ]
}
```
## Adding policies and rules to the firewall
```
resource "azurerm_firewall_network_rule_collection" "example" {
  name                = "testcollection"
  azure_firewall_name = module.afw.afw_out.name
  resource_group_name = azurerm_resource_group.avatest.name
  priority            = 100
  action              = "Allow"

  rule {
    name = "testrule"

    source_addresses = [
      "10.0.0.0/16",
    ]

    destination_ports = [
      "53",
    ]

    destination_addresses = [
      "8.8.8.8",
      "8.8.4.4",
    ]

    protocols = [
      "TCP",
      "UDP",
    ]
  }
}
```
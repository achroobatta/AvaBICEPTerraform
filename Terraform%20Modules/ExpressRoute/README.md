# Introduction 
Create a ExpressRoute Gateway and optional circuits. Circuits provisioned by this module comes with diagnostics onnboarding with Azure Monitor module.

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
| virtual_hub_id | virtual_hub_id to attach the gateway | string |



# Optional/Advance Parameters
Reference for express route gateway resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_gateway

Reference for express route circuit resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/express_route_circuit

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor| The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| logging_retention | Retention period of diagnostics configuration  | 30 | number |
| scale_units | refer express_route_gateway resource provider for usage  | 1 | number |
| circuits | create express route circuits, refer to express_route_circuit resource provider for usage | null | list(object({<br/>name = string<br/>service_provider_name = string<br/>peering_location = string<br/>bandwidth_in_mbps = number<br/>bandwidth_in_gbps = number<br/>express_route_port_id = string<br/>allow_classic_operations = bool<br/>sku_tier = string<br/>sku_family = string<br/>})) |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| ergw_out | Output of the express route gateway | any |
| circuits_out | Output of the express route circuits created by this module | any |

# Additional details
## Simple code sample
```
module "expressroute" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//ExpressRoute"
  name         = "testexpressroute"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  virtual_hub_id = module.hub.hub_out.id
  circuits = [{
    name = "circuit1"
    service_provider_name = "Equinix"
    peering_location = "Silicon Valley"
    bandwidth_in_mbps = 50
    bandwidth_in_gbps = null
    express_route_port_id = null
    allow_classic_operations = null
    sku_tier = "Standard"
    sku_family = "MeteredData"
  }]
  azure_monitor = module.azure_monitor
}
```
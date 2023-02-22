# Introduction 
Provision load balancer module with the following optional configurations to accelerate common deployments:
- ONE backend pool containing one or more NICs, with one loadbalancing rule and one health probe (check "backendpool_configuration" parameter for full detail of what is configured)
- One or Many NAT rules

User can still choose to proivision additional loadbalancing configurations to the load balancer provisioned by this module via their respective resource providers as shown in the sample.

There is no multiple backend pool support possible due to Terraform lack of nested for loops.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
This module has no dependencies as it has no diagnostics logs
| Module Name | Description | Tested Version |
|---|---|---|


# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| name | Name of the LB | string |
| location | Azure region of where to provision the LB | string |
| resource_group_name | Name of the RG | string |
| sku | loadbalancer sku | string |
| tags | Azure Tags | map |
| frontend_ip_configurations | configuration for frontend_ip_configuration block | list(object({<br/>name = string<br/>private_ip_address = string<br/>public_ip_address_id = string<br/>public_ip_prefix_id = string<br/>zones = list(string)<br/>subnet_id = string<br/>gateway_load_balancer_frontend_ip_configuration_id = string<br/>private_ip_address_allocation = string<br/>private_ip_address_version = string<br/>})) |



# Optional/Advance Parameters
Reference for load balancer resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb

Reference for LB rule resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_rule

Reference for backend pool resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_backend_address_pool

Reference for backend pool association resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_backend_address_pool_association

Reference for NAT rule resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb_nat_rule

Reference for NAT rule association resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface_nat_rule_association

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| azure_monitor| The Azure Monitor Module's output | null | Output of Azure Monitor module <br/>e.g.:azure_monitor = module.azure_monitor |
| logging_retention | Retention period of diagnostics configuration  | 30 | number |
| edge_zone | refer to loadbalancer resource provider for usage | null | string |
| sku_tier | refer to loadbalancer resource provider for usage | null | string |
| nat_configurations | Allow creation of one or many NAT configurations with default configurations for advance settings.<br/>name = name of NAT configuration objects<br/>network_interface_id = NIC card ID<br/>ip_configuration_name = name of ip configuration of the NIC card attached<br/>frontend_ip_configuration_name = name of frontend ip configuration of the load balancer to be used<br/>protocol = accept "Udp", "Tcp" or "All"<br/>frontend_port = front end port number<br/>backend_port = back end port number | null | list(object({<br/>name = string<br/>network_interface_id = string<br/>ip_configuration_name = string<br/>frontend_ip_configuration_name = string<br/>protocol = string<br/>frontend_port = number<br/>backend_port = number<br/>})) |
| backendpool_configuration | Allow creation of one backend pool with one or multiple NIC cards, one probe, one load balancing rule with default configuration for advance settings.<br/>name = name of the backendpool, probe and lb rule<br/>network_interface_ids = list of NIC card IDs<br/>ip_configuration_names = list of corresponding ip configuration names of the network_interface_ids<br/>frontend_ip_configuration_name= front ip configuration of the load balancer<br/>probe_protocol = probe protocol, accept "Https", "Tcp" and "Http"<br/>protocol = protocol of lb rule accept "Udp", "Tcp" or "All"<br/>frontend_port = front end port number<br/>backend_port = back end port number that is used for probe port as well| null | object({<br/>name = string<br/>network_interface_ids = list(string)<br/>ip_configuration_names = list(string)<br/>frontend_ip_configuration_name= string<br/>probe_protocol = string<br/>protocol = string<br/>frontend_port = number<br/>backend_port = number<br/>}) |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| lb_out | Load balancer object | Any |

# Additional details
## Sample usage with creation of one backend pool and NAT rule via the module built in function
```
module "lb"{
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//LoadBalancer/"
  name  = "avatestlb"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  sku = "Standard"
  frontend_ip_configurations=[{
    name = "fip"
    private_ip_address = null
    public_ip_address_id = null
    public_ip_prefix_id = null
    zones = null
    subnet_id = module.vnetmodule.subnets_out[0].id
    gateway_load_balancer_frontend_ip_configuration_id = null
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version = null
  }]
  nat_configurations=[{
    name = "linvm"
    network_interface_id  = module.linvm.vm_nics_out[0].id
    ip_configuration_name = module.linvm.vm_nics_out[0].ip_configuration[0].name
    frontend_ip_configuration_name = "avatestlb-fip"
    protocol = "Tcp"
    frontend_port = "22"
    backend_port = "22"
  }]

  backendpool_configuration={
    name = "vmpool2"
    network_interface_ids  = ["${module.linvm.vm_nics_out[0].id}","${module.winvm.vm_nics_out[0].id}"]
    ip_configuration_names = ["${module.linvm.vm_nics_out[0].ip_configuration[0].name}", "${module.winvm.vm_nics_out[0].ip_configuration[0].name}"]
    frontend_ip_configuration_name = "avatestlb-fip"
    probe_protocol = "Https"
    protocol = "Tcp"
    frontend_port = "443"
    backend_port = "443"
  }
}
```

## Adding additional or advance settings backend pools via resource providers
```
resource "azurerm_lb_backend_address_pool" "vmpool" {
  loadbalancer_id = module.lb.lb_out.id
  name            = "vmpool"
}

resource "azurerm_network_interface_backend_address_pool_association" "winvmbackend" {
  network_interface_id  = module.winvm.vm_nics_out[0].id
  ip_configuration_name = module.winvm.vm_nics_out[0].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.vmpool.id
}
```
# Introduction 
This module creates public ip and application gateway.
Virtual network, subnets and NSGs' creation are imported from the Virtual Network module.
Azure monitor onboarding module is imported into this to configure the logs and metrics for application gateway. Additionally, logs and metrics for public ip can also be configured by reusing the azure monitor module.
SSL certificate and SSL policy are optional blocks for use in this module. The creation of SSL certificate or key vault secret id is not provisioned in this module.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.4 | Dec22 | Added rewrite rule set capability | viktor.lee |
| 1.3 | Nov22 | Fixed ssl policy capability to support custom cipher suite | viktor.lee |
| 1.2 | Nov22 | Fixed ssl variable to allow AKV certs | viktor.lee |
| 1.1 | Nov22 | Fixed missing parameter in probes and request_routing_rule block, Added PIP IP SKU variable | viktor.lee |
| 1.0 | Ausgust22 | First release | santosh.manne |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.4 | 1.3.6 | 3.34.0 |
| 1.3 | 1.3.4 | 3.31.0 |
| 1.2 | 1.3.4 | 3.31.0 |
| 1.1 | 1.3.3 | 3.30.0 |
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
| Module Name | Description | Tested Version |
|---|---|---|
| AzureMonitor | Required provisioning of required log analytics, event hub and storage account required for diagnostics logging | 1.0 |
| AzureMonitorOnboarding | Optional onboard and configure diagnostics to resources provisioned by AzureMonitor module | 1.0 |
| VirtualNetwork | Required provisioning of vnet, subnets and NSGs | 1.0 |

# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| public_ip_name | Name of the public ip | string |
| resource_group_name | Name of the resource group | string |
| location | Location in which the resources reside | string |
| allocation_method | Allocation method for the ip address | string |
| public_ip_sku | SKU of the public ip | string |
| apllication_gateway_name | Name of the application gateway | string |
| tags | tags of the app gateway | map(string) |
| sku | The sku pricing model | object({<br/>name = string<br/>tier = string<br/>capacity = number<br/>})) | 
| frontend_http_port |  Frontend port used to listen for HTTP traffic | number |
| frontend_https_port | Frontend port used to listen for HTTPS traffic | number |
| subnet_id | Subnet id which the Application Gateway should be connected to | string |
| backend_https_settings | List of backend http settings |  list(object({<br/>name = string <br/>path = string<br/>port = number<br/>protocol = string<br/>enable_cookie_based_affinity<br/>request_timeout = number<br/>probe_name = string<br/>host_name = string<br/>pick_host_name_from_backend_address = bool<br/>}))|
| http_listeners | list of http/https listeners | list(object({<br/>name = string<br/>ssl_certificate_name = string<br/>bost_name = string<br/>host_names = list(string)<br/>require_sni<br/>})) |
| basic_request_routing_rules | Request routing rules | list(object({<br/>name = string<br/>http_listener_name = name<br/>backend_address_pool_name = string<br/>backend_http_settings_name = string<br/>})) |
 redirect_request_routing_rules | Redirecting routing rules | list(object({<br/>name = string<br/>http_listener_name = string<br/>redirect_configuration_name = string<br/>})) | 
| path_based_request_routing_rules | Path based routing rules | list(object({<br/>name = string<br/>http_listener_name = string<br/>url_path_map_name = string<br/>})) |
| azure_monitor | Azure monitor module output | null | |

# Optional/Advance Parameters

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| enable_http2 | Is HTTP2 enabled on the application gateway | false | boolean |
| fips_enabled | Is FIPS enabled on the Application Gateway? | false | boolean |
| force_firewall_policy_association | Is the Firewall Policy associated with the App Gateway | false | boolean |
| firewall_policy_id | ID of the web app firewall policy | null | string |
| autoscale_configuration | Autoscaling capacities | null | object({<br/>min_capacity = number<br/>max_capacity = number<br/>}) |
| authentication_certificate | list of app gateway authentication certificate | [] | list["string1", "string2"] |
| trusted_root_certificate_names | list of trusted_root_certificate names | [] | list["string1", "string2"] |
| connection_draining | connection draining | null | object({<br/>enabled = bool<br/>drain_timeout_sec = number<br/>})|
| custom_error_configuration | custom error configuration | null | object({<br/>status_code = string<br/>custom_error_page_url = string<br/>}) |
| identity_ids | list with a single user managed identity | null | list["string1", "string2"] |
| probes | Health probes to test backend health | [] | list(object({<br/>host = string<br/>name = string<br/>path = string<br/>protocol = string<br/>interval = number<br/>timeout = number<br/>unhealthy_threshold = number<br/>port = number<br/>minimum_servers = number<br/>match_body = string<br/>match_status_codes = list(string)<br/>pick_host_name_from_backend_http_settings = bool<br/>})) | 
| ssl_certificates | list of ssl certificates | [] | list(object({<br/> name = string<br/>pfx_data = string<br/>pfx_password = string<br/>})) |
| ssl_policy | define TLS settings if required | null | object({<br/>disabled_protocols = list(string)<br/>policy_type = string<br/>policy_name = string<br/>cipher_suites = list(string)<br/>min_protocol_version = string<br/>}) | 
| logging_retention | Retention period of azure_monitor configuration | 30 | number |

# Outputs
| Parameter Name | Description | Type | 
|---|---|---|
| pip_out | Output of public ip | any | 
| gateway_out | Output of application gateway | any | 

# Locals
## For ease of using names
| Name | Value | 
|---|---|
| http_frontend_port_name | "${var.application_gateway_name}-http-port" |
|  https_frontend_port_name | "${var.application_gateway_name}-https-port" |
| frontend_ip_configuration_name | "${var.application_gateway_name}-feip" |
| http_listener_name | "${var.application_gateway_name}-httplstn" |
| https_listener_name | "${var.application_gateway_name}-httpslstn" | 
| http_request_routing_rule_name | "${var.application_gateway_name}-http-rqrt" |
| https_request_routing_rule_name | "${var.application_gateway_name}-https-rqrt" |
| http_setting_name | "${var.application_gateway_name}-be-http-st" |
| redirect_configuration_name | "${var.application_gateway_name}-rdrcfg" | 

# Reference
Application Gateway : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_gateway

# Additional details
## Sample usage when using this module in your own modules
```
module "gateway" {
  source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules/ApplicationGateway"
  application_gateway_name                = "example-appgateway"
  public_ip_name = "publicpip"
  resource_group_name = azurerm_resource_group.avatest.name
  location            = "Australia East"
  allocation_method   = "Dynamic" 
  tags         = {
    environment = "sandbox"
  }
  sku = {
    name     = "Standard_Small"
    tier     = "Standard"
    capacity = 2
  }
  subnet_id = module.vnet.subnets_out[1].id
  backend_address_pools = [
    {
      name         = "bkpool"
      ip_addresses = ["10.0.1.10", "10.0.1.11"]
      fqdns        = null
    }
  ]
  backend_http_settings = [
    {
      name                         = "backendhttp"
      path                         = "/"
      port                         = 80
      protocol                     = "Http"
      enable_cookie_based_affinity = true
      request_timeout              = 60
      probe_name                   = null
      pick_host_name_from_backend_address = false
      host_name                     = "example"
      
    }
  ]
  http_listeners = [
    {
      name                 = "httplistener"
      require_sni          = false
      ssl_certificate_name = null
      host_name            = null
      host_names           = []
    }
  ]
  basic_request_routing_rules =  [
    {
      name                       = "testroutingrule"
      http_listener_name         = "httplistener"
      backend_address_pool_name  = "bkpool"
      backend_http_settings_name = "backendhttp"
      
    }
  ]
```
## Importing vnet module to create vnet, subnets and nsgs.

resource "azurerm_resource_group" "avatest" {
  name     = "avatest"
  location = "Australia East"
}
module "vnet" {
  source                       = "./VirtualNetwork/"
  virtual_network_name         = "avavnet"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  address_space = ["10.0.0.0/16"]
  subnet_definition = [{
    name = "subnetA"
    prefix = ["10.0.0.0/24"]
    service_endpoints = []
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = false
    delegations = []
  },{
    name = "subnetB"
    prefix = ["10.0.1.0/24"]
    service_endpoints = []
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = false
    delegations = []
  }]
  tags         = {
    environment = "sandbox"
  }
}
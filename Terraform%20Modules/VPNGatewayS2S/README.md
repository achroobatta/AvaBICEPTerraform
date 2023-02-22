# Introduction 
Creates a site 2 site vpn server and optional vpn site and connection.
var.links is used to determine if the vpn site and connection is created by this module. It is also used to create both the links and vpn_links within the two resource.VPN site and connection created by this module will all have the same IPSEC policy(s). User can choose to create vpn site and connection outside of the module if this is not desired. Alternatively, users can choose to use resource provider exclusively in such a scenario as the module do not provide additional value when creating the VPN gateway only.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | Aug22 | First release | viktor.lee |

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
| virtual_hub_id | virtual_hub_id to attach the gateway | string |
| virtual_wan_id | virtual_wan_id to attach the gateway | string |
| address_cidrs | address_cidrs of vpn site, refer to vpn_site resource provider for usage | list(string) |


# Optional/Advance Parameters
Reference for s2s vpn gateway resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway

Reference for vpn site: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_site

Reference for vpn connection: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_gateway_connection

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| bgp_route_translation_for_nat_enabled | refer vpn_gateway resource provider for usage | null| bool |
| routing_preference | refer vpn_gateway resource provider for usage | null| string |
| scale_unit | refer vpn_gateway resource provider for usage | 1 | number |
| bgp_settings | bgp_setting block, refer vpn_gateway resource provider for usage | null | object({<br/>asn = string<br/>peer_weight = number<br/>instance_0_bgp_peering_address_custom_ips = list(string)<br/>instance_1_bgp_peering_address_custom_ips = list(string)<br/>}) |
| device_model | refer vpn_gateway resource provider for usage | null | string |
| device_vendor | refer vpn_gateway resource provider for usage | null | string |
| o365_policy | o365_policy block, refer vpn_site resource provider for usage | null | object({<br/>allow_endpoint_enabled = bool<br/>default_endpoint_enabled = bool<br/>optimize_endpoint_enabled = bool<br/>}) |
| links | one or more link and vpn_link block used in both vpn_site and vpn_gateway_connection. Refer vpn_site and vpn_gateway_connection resource provider for usage. When left empty, module will not create vpn_site and vpn_gw_connection. BGP nested block will only be created when both bgp_asn and bgp_peering_address is populated | null | list(object({<br/>#shared for vpn_site and vpn_gw_connection variables<br/>name = string<br/>ip_address = string<br/>speed_in_mbps = number<br/>#used for vpn_site <br/>fqdn = string<br/>provider_name = string<br/>bgp_asn = string<br/>bgp_peering_address = string<br/>#used for vpn_gw_connection<br/>bgp_enabled = bool<br/>connection_mode = string<br/>protocol = string<br/>egress_nat_rule_ids = list(string)<br/>ingress_nat_rule_ids = list(string)<br/>ratelimit_enabled = bool<br/>route_weight = number<br/>shared_key = string<br/>local_azure_ip_address_enabled = bool<br/>policy_based_traffic_selector_enabled = bool<br/>custom_bgp_ip_address = string<br/>custom_bgp_ip_configuration_id = string<br/>})) |
| traffic_selector_policies | traffic_selector_policy block, refer vpn_gateway_connection resource provider for usage | null | list(object({<br/>local_address_ranges = list(string)<br/>remote_address_ranges = list(string)<br/>})) |
| associated_route_table | refer to routing block vpn_gateway_connection resource provider for usage | null | string |
| propagated_route_table | routing block, refer vpn_gateway_connection resource provider for usage | null | object({<br/>route_table_ids = list(string)<br/>labels = list(string)<br/>}) |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| s2sgw_out | Output of the p2s gateway | any |


# Additional details
## Simple code sample
```
module "vpns2s" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VPNGatewayS2S"
  name         = "vpns2s"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  virtual_hub_id = module.hub.hub_out.id
  virtual_wan_id = module.hub.wan_out.id
  address_cidrs = [ "10.0.0.0/24" ]
  links = [{
    name = "link1"
    fqdn = null
    ip_address = "10.0.0.1"
    provider_name = null
    speed_in_mbps =null
    bgp_asn = null
    bgp_peering_address = null
    bgp_enabled = null
    connection_mode = null
    protocol = null
    egress_nat_rule_ids = null
    ingress_nat_rule_ids = null
    ratelimit_enabled = null
    route_weight = null
    shared_key = null
    local_azure_ip_address_enabled = null
    policy_based_traffic_selector_enabled = null
    custom_bgp_ip_address = null
    custom_bgp_ip_configuration_id = null
  }]
}
```
#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the vpn gw"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the vpn gw"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map
}

variable "virtual_hub_id" {
  description = "(Required) virtual_hub_id"
  type        = string
}

variable "virtual_wan_id" {
  description = "(Required) virtual_wan_id"
  type        = string
}

variable "address_cidrs" {
  description = "(Required) refer to vpn_site resource provider for usage"
  type        = list(string)
}
#Optional variables###############################################################################
variable "bgp_route_translation_for_nat_enabled" {
  description = "(Optional) refer to vpn_gateway resource provider for usage"
  type        = bool
  default = null
}

variable "routing_preference" {
  description = "(Optional) refer to vpn_gateway resource provider for usage"
  type        = string
  default = null
}

variable "scale_unit" {
  description = "(Optional) refer to vpn_gateway resource provider for usage"
  type        = number
  default = 1
}

variable "bgp_settings" {
  description = "(Optional)bgp_setting block, refer vpn_gateway resource provider for usage"
  type = object({
    asn = string
    peer_weight = number
    instance_0_bgp_peering_address_custom_ips = list(string)
    instance_1_bgp_peering_address_custom_ips = list(string)
  })
  default = null
}

variable "device_model" {
  description = "(Optional) refer to vpn_site resource provider for usage"
  type        = string
  default = null
}

variable "device_vendor" {
  description = "(Optional) refer to vpn_site resource provider for usage"
  type        = string
  default = null
}

variable "o365_policy" {
  description = "(Optional)o365_policy block, refer vpn_site resource provider for usage"
  type = object({
    allow_endpoint_enabled = bool
    default_endpoint_enabled = bool
    optimize_endpoint_enabled = bool
  })
  default = null
}

variable "links" {
  description = "(Optional)one or more link and vpn_link block used in both vpn_site and vpn_gateway_connection. Refer vpn_site and vpn_gateway_connection resource provider for usage. When left empty, module will not create vpn_site and vpn_gw_connection. BGP nested block will only be created when both bgp_asn and bgp_peering_address is populated"
  type = list(object({
    #shared for vpn_site and vpn_gw_connection variables
    name = string
    ip_address = string
    speed_in_mbps = number
    #used for vpn_site 
    fqdn = string
    provider_name = string
    bgp_asn = string
    bgp_peering_address = string
    #used for vpn_gw_connection
    bgp_enabled = bool
    connection_mode = string
    protocol = string
    egress_nat_rule_ids = list(string)
    ingress_nat_rule_ids = list(string)
    ratelimit_enabled = bool
    route_weight = number
    shared_key = string
    local_azure_ip_address_enabled = bool
    policy_based_traffic_selector_enabled = bool
    custom_bgp_ip_address = string
    custom_bgp_ip_configuration_id = string
  }))
  default = null
}

variable "ipsec_policies" {
  description = "(Optional)vpn_link block, refer vpn_gateway_connection resource provider for usage. Module only accepts a single IPSEC settings for all links."
  type = list(object({
    dh_group = string
    ike_encryption_algorithm = string
    ike_integrity_algorithm = string
    encryption_algorithm = string
    integrity_algorithm = string
    pfs_group = string
    sa_lifetime_sec= number
    sa_data_size_kb = number
  }))
  default = null
}

variable "traffic_selector_policies" {
  description = "(Optional)traffic_selector_policy block, refer vpn_gateway_connection resource provider for usage"
  type = list(object({
    local_address_ranges = list(string)
    remote_address_ranges = list(string)
  }))
  default = null
}

variable "associated_route_table" {
  description = "(Optional) refer to routing block vpn_gateway_connection resource provider for usage"
  type        = string
  default = null
}

variable "propagated_route_table" {
  description = "(Optional)routing block, refer vpn_gateway_connection resource provider for usage"
  type = object({
    route_table_ids = list(string)
    labels = list(string)
  })
  default = null
}
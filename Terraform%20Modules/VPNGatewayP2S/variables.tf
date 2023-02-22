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

variable "vpn_authentication_types" {
  description = "(Required) VPN authentication types"
  type        = list(string)
}

variable "virtual_hub_id" {
  description = "(Required) virtual_hub_id"
  type        = string
}

variable "address_prefixes" {
  description = "(Required) VPN gateway address_prefixes"
  type        = list(string)
}


#Optional variables###############################################################################
variable "vpn_protocols" {
  description = "(Optional) VPN portocols to be used"
  type        = list(string)
  default = null
}

variable "ipsec_policy" {
  description = "(Optional)route block, refer vpn_server_configuration resource provider for usage"
  type = object({
    dh_group = string
    ike_encryption = string
    ike_integrity = string
    ipsec_encryption = string
    ipsec_integrity = string
    pfs_group = string
    sa_lifetime_seconds = number
    sa_data_size_kilobytes = number
  })
  default = null
}

variable "azure_active_directory_authentication" {
  description = "(Optional)azure_active_directory_authentication block, refer vpn_server_configuration resource provider for usage"
  type = object({
    audience = string
    issuer = string
    tenant = string
  })
  default = null
}

variable "client_root_certificates" {
  description = "(Optional)client_root_certificate block, refer vpn_server_configuration resource provider for usage"
  type = list(object({
    name = string
    public_cert_data = string
  }))
  default = null
}

variable "client_revoked_certificates" {
  description = "(Optional)client_revoked_certificate block, refer vpn_server_configuration resource provider for usage"
  type = list(object({
    name = string
    thumbprint = string
  }))
  default = null
}

variable "radius_client_root_certificates" {
  description = "(Optional)raduis client_root_certificate block, refer vpn_server_configuration resource provider for usage"
  type = list(object({
    name = string
    thumbprint = string
  }))
  default = null
}

variable "radius_server_root_certificates" {
  description = "(Optional)raduis server_root_certificate block, refer vpn_server_configuration resource provider for usage"
  type = list(object({
    name = string
    public_cert_data = string
  }))
  default = null
}

variable "radius_servers" {
  description = "(Optional)raduis server block, refer vpn_server_configuration resource provider for usage"
  type = list(object({
    address = string
    secret = string
    score = number
  }))
  default = null
}

variable "scale_unit" {
  description = "(Optional) refer point_to_site_vpn_gateway resource provider for usage"
  type        = number
  default = 1
}

variable "dns_servers" {
  description = "(Optional) refer point_to_site_vpn_gateway resource provider for usage"
  type        = list(string)
  default = null
}

variable "internet_security_enabled" {
  description = "(Optional) refer to connection_configuration block point_to_site_vpn_gateway resource provider for usage"
  type        = string
  default = null
}

variable "associated_route_table_id" {
  description = "(Optional) refer to connection_configuration block point_to_site_vpn_gateway resource provider for usage"
  type        = string
  default = null
}

variable "propagated_route_table" {
  description = "(Optional)refer to connection_configuration block point_to_site_vpn_gateway resource provider for usage"
  type = object({
    ids = list(string)
    labels = list(string)
  })
  default = null
}
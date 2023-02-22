#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the hub network"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the hub network"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map
}

variable "wan_type" {
  description = "(Required) Address prefix of the hub"
  type        = string
}

variable "hub_sku" {
  description = "(Required) Address prefix of the hub"
  type        = string
}

variable "hub_address_prefix" {
  description = "(Required) Address prefix of the hub"
  type        = string
}


#Optional variables###############################################################################
variable "disable_vpn_encryption" {
  description = "(Optional) refer to azurerm_virtual_wan resource provider for usage"
  default = null
  type = bool
}

variable "allow_branch_to_branch_traffic" {
  description = "(Optional) refer to azurerm_virtual_wan resource provider for usage"
  default = null
  type = bool
}

variable "office365_local_breakout_category" {
  description = "(Optional) refer to azurerm_virtual_wan resource provider for usage"
  default = null
  type = string
}

variable "routes" {
  description = "(Optional)route block"
  type = list(object({
    address_prefixes = list(string)
    next_hop_ip_address = string
  }))
  default = null
}
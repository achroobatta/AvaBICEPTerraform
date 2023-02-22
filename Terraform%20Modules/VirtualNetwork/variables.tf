#Require variables###############################################################################
variable "virtual_network_name" {
  description = "(Required) Name of the vnet"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource groups will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the vnet"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map
}

variable "address_space" {
  description = "(Required) Address space of VNET"
  type        = list(string)
}

variable "subnet_definition" {
  description = "(Required) List of subnets"
  type = list(object({
    name = string
    prefix = list(string)
    service_endpoints = list(string)
    enforce_private_link_endpoint_network_policies = bool
    enforce_private_link_service_network_policies = bool
    delegations = list(string)
  }))
}



#Optional variables###############################################################################

variable "azure_monitor" {
  description = "(Optional) Azure Monitor module output to configure monitoring"
  default = null
}

variable "ddos_protection_plan_id" {
  description = "(Optional) define ddos protection plan id to be used"
  default = null
  type = string
}

variable "dns_servers" {
  description = "(Optional) List of DNS servers"
  type        = list(string)
  default = null
}

variable "logging_retention" {
  description = "(Optional) Retention period of azure_monitor configuration"
  default = 30
  type=number
}

variable "network_watcher_name" {
  description = "(Optional) network watcher name to attach to"
  default = null
  type=string
}

variable "network_watcher_resource_group_name" {
  description = "(Optional) Resoruce group that network watcher is residing in"
  default = null
  type=string
}


variable "network_watcher_retention" {
  description = "(Optional) Retention period of network watcher"
  default = 7
  type=number
}

variable "bgp_community" {
  description = "(Optional) refer to azurerm_virtual_network provider for usage"
  default = null
  type=string
}

variable "edge_zone" {
  description = "(Optional) refer to azurerm_virtual_network provider for usage"
  default = null
  type=string
}

variable "flow_timeout_in_minutes" {
  description = "(Optional) refer to azurerm_virtual_network provider for usage"
  default = null
  type = number
}


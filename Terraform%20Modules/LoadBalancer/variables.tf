#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the loadbalancer"
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

variable "sku" {
  description = "(Required) loadbalancer sku"
  type = string
}

variable "frontend_ip_configurations" {
  description = "(Required) front end ip configuration list"
  type=list(object({
    name = string
    private_ip_address = string
    public_ip_address_id = string
    public_ip_prefix_id = string
    zones = list(string)
    subnet_id = string
    gateway_load_balancer_frontend_ip_configuration_id = string
    private_ip_address_allocation = string
    private_ip_address_version = string
  }))
}

#Optional variables###############################################################################
variable "azure_monitor" {
  description = "(Optional) Azure Monitor module output to configure monitoring"
  default = null
}

variable "logging_retention" {
  description = "(Optional) Retention period of azure_monitor configuration"
  default = 30
  type=number
}

variable "edge_zone" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type = string
}

variable "sku_tier" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type = string
}

variable "nat_configurations" {
  description = "(Optional) NAT Configurations"
  type=list(object({
    name = string
    network_interface_id = string
    ip_configuration_name = string
    frontend_ip_configuration_name = string
    protocol = string
    frontend_port = number
    backend_port = number
  }))
  default = null
}

variable "backendpool_configuration" {
  description = "(Optional) allow defintion of ONE backend pool Configuration"
  type=object({
    name = string
    network_interface_ids = list(string)
    ip_configuration_names = list(string)
    frontend_ip_configuration_name= string
    probe_protocol = string
    protocol = string
    frontend_port = number
    backend_port = number
  })
  default = null
}
#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the afw"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the Afw"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map
}

variable "sku_name" {
  description = "(Required) SKU name of Afw"
  type        = string
}

variable "sku_tier" {
  description = "(Required) SKU tier name of Afw"
  type        = string
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

variable "ip_configurations" {
  description = "(Optional)ip_configuration_block"
  type = list(object({
    name = string
    subnet_id  = string
    public_ip_address_id = string
  }))
  default = null
}

variable "firewall_policy_id" {
  description = "(Optional) Refer to resource provider for usage"
  type        = string
  default = null
}

variable "dns_servers" {
  description = "(Optional) Refer to resource provider for usage"
  type        = list(string)
  default = null
}

variable "private_ip_ranges" {
  description = "(Optional) Refer to resource provider for usage"
  type        = list(string)
  default = null
}

variable "threat_intel_mode" {
  description = "(Optional) Refer to resource provider for usage"
  type        = string
  default = null
}

variable "zones" {
  description = "(Optional) Refer to resource provider for usage"
  type        = list(string)
  default = null
}

variable "virtual_hub" {
  description = "(Required)virtual_hub block"
  type = object({
    virtual_hub_id = string
    public_ip_count = number
  })
  default = null
}

variable "management_ip_configuration" {
  description = "(Required)management_ip_configuration"
  type = object({
    name = string
    subnet_id = string
    public_ip_address_id = string
  })
  default = null
}
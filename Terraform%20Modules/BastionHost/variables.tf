#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the Bastion"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the Bastion"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map
}

variable "sku" {
  description = "(Required) SKU of Bastion"
  type        = string
}

variable "ip_configuration" {
  description = "(Required)ip_configuration_block"
  type = object({
    name = string
    subnet_id  = string
    public_ip_address_id = string
  })
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

variable "copy_paste_enabled" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type=bool
}

variable "file_copy_enabled" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type=bool
}

variable "ip_connect_enabled" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type=bool
}

variable "shareable_link_enabled" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type=bool
}

variable "tunneling_enabled" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type=bool
}

variable "scale_units" {
  description = "(Optional) refer to resource provider for usage"
  default = null
  type=number
}
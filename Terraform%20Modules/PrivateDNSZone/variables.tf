#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the Bastion"
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

#Optional variables###############################################################################
variable "soa_record" {
  description = "(Optional) SOA record block"
  type = object({
    email = string
    expire_time = number
    minimum_ttl = number
    refresh_time = number
    retry_time = number
    ttl = number
  })
  default = null
}

variable "virtual_network_ids" {
  description = "(Optional) virtual_network_ids to link to the private dns zone"
  type = list(object({
    id= string
    registration_enabled = bool
  }))
  default = null
}
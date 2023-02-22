#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the akv"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the AKV"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map
}



#Optional variables###############################################################################
variable "azure_monitor" {
  description = "(Optional) Azure Monitor module output to configure monitoring"
  default = null
}

variable "sku_name" {
  description = "(Optional) SKU name of AKV"
  type        = string
  default = "standard"
}

variable "enabled_for_deployment" {
  description = "(Optional) Refer to resource provider for usage"
  type        = bool
  default = false
}

variable "enabled_for_disk_encryption" {
  description = "(Optional) Refer to resource provider for usage"
  type        = bool
  default = false
}

variable "enabled_for_template_deployment" {
  description = "(Optional) Refer to resource provider for usage"
  type        = bool
  default = false
}

variable "enable_rbac_authorization" {
  description = "(Optional) Refer to resource provider for usage"
  type        = bool
  default = false
}

variable "soft_delete_retention_days" {
  description = "(Optional) Refer to resource provider for usage"
  type        = number
  default = 7
}

variable "purge_protection_enabled" {
  description = "(Optional) Refer to resource provider for usage"
  type        = bool
  default = false
}

variable "purge_soft_delete_on_destroy" {
  description = "(Optional) purge_soft_delete_on_destroy in Azure feature block"
  type        = bool
  default = true
}

variable "network_acls" {
  description = "(Optional) Network rules to apply to key vault."
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "contacts" {
  description = "(Optional) Contact information to send notifications triggered by certificate lifetime events"
  type = list(object({
    email = string
    name  = string
    phone = string
  }))
  default = []
}
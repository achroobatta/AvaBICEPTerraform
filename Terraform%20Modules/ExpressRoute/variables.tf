#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the express route"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the express route"
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

variable "scale_units" {
  description = "(Optional) refer express_route_gateway resource provider for usage"
  type        = number
  default = 1
}

variable "circuits" {
  description = "(Optional)create express route circuits, refer to express_route_circuit resource provider for usage"
  type = list(object({
    name = string
    service_provider_name = string
    peering_location = string
    bandwidth_in_mbps = number
    bandwidth_in_gbps = number
    express_route_port_id = string
    allow_classic_operations = bool
    sku_tier = string
    sku_family = string
  }))
  default = null
}
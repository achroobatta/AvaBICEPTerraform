#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the logging module"
  type        = string
}

variable "location" {
  description = "(Required) region of the logging module"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) rg of the logging module"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the logging module"
  type        = map
}

#Optional variables###############################################################################
variable "log_analytics_workspace_sku" {
  description = "(Optional) sku for the law, default is PerGB2018"
  type        = string
  default     = "PerGB2018"
}

variable "log_analytics_workspace_retention" {
  description = "(Optional) retention for the law, default is 30"
  type        = number
  default     = 30
}

variable "log_analytics_workspace_daily_quota" {
  description = "(Optional) Log analytics workspace daily quota in GB"
  type        = number
  default     = -1
}

variable "log_analytics_workspace_ingestion" {
  description = "(Optional) Log analytics workspace ingestion over the internet"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_query" {
  description = "(Optional) Log analytics workspace query over the internet"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_reservation" {
  description = "(Optional) Log analytics workspace reservation if sku is set to CapacityReservation"
  type        = number
  default     = null
}

variable "eventhub_required" {
  description = "(Optional) is eventhub required?"
  type        = string
  default     = false
}

variable "eventhub_sku" {
  description = "(Optional) sku for the eh, default is basic"
  type        = string
  default     = "Basic"
}

variable "eventhub_parition_count" {
  description = "(Optional) Eventhub partition count"
  type        = number
  default     = 4
}

variable "eventhub_capacity" {
  description = "(Optional)Eventhub partition capacity if sku is Standard"
  type        = number
  default     = 2
}

variable "eventhub_zone_redundant" {
  description = "(Optional)Eventhub partition capacity if sku is Standard"
  type        = bool
  default     = false
}

variable "eventhub_auto_inflate" {
  description = "(Optional)Eventhub auto inflate settings"
  type        = bool
  default     = false
}

variable "eventhub_throughput" {
  description = "(Optional)Eventhub throughput if auto inflate is set to true"
  type        = number
  default     = null
}

variable "eventhub_dedicated_cluster" {
  description = "(Optional)Eventhub dedicated cluster id"
  type        = string
  default     = null
}


variable "eventhub_message_retention" {
  description = "(Optional)Eventhub throughput if auto inflate is set to true"
  type        = number
  default     = 1
}

variable "eventhub_status" {
  description = "(Optional)Eventhub status"
  type        = string
  default     = "Active"
}

variable "eventhub_network_rules" {
  description = "Network rules restricting access to the event hub."
  type = object({
    trusted_service_access_enabled = bool
    ip_rules   = list(string)
    subnet_ids = list(string)
  })
  default = null
}

variable "storage_account_required" {
  description = "(Optional) is storage account required?"
  type        = string
  default     = false
}

variable "storage_account_tier" {
  description = "(Optional) tier for the sa, default is standard"
  type        = string
  default     = "Standard"
}

variable "storage_account_replication_type" {
  description = "(Optional) Storage account replication type"
  type        = string
  default     = "LRS"
}

variable "storage_account_kind" {
  description = "(Optional) Storage account kind"
  type        = string
  default     = "StorageV2"
}

variable "storage_account_access_tier" {
  description = "(Optional) Storage account access tier"
  type        = string
  default     = "Cool"
}
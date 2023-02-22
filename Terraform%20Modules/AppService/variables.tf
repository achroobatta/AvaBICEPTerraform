#**************************** App Service Plan Variables ************************************
variable "app_service_name" {
  description = "(Required) Name of the App service plan"
  type        = string
}
variable "resource_group_name" {
  description = "(Required) Name of the resource group"
  type        = string
}
variable "location" {
  description = "(Required) Location of the App Service plan"
  type        = string
}
variable "os_type" {
  description = "(Required) The O/S type for the App Services to be hosted in this plan. Possible values: 'Windows', 'Linux' & 'WindowsContainer'"
  type        = string
}
variable "sku_name" {
  description = "(Required) The SKU for the plan"
  type        = string
}
variable "tags" {
  description = "(Required) map of tags "
  type        = map
}
variable "app_service_environment_id" {
  description = "(Optional) The ID of the App Service Environment. Requires an Isolated SKU"
  default     = null
  type        = string
}
variable "maximum_elastic_worker_count" {
  description = "(Optional) The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU."
  default     = null
  type        = number
}
variable "worker_count" {
  description = "(Optional) The number of Workers (instances) to be allocated."
  default     = null
  type        = number
}
variable "per_site_scaling_enabled" {
  description = "(Optional) Should Per Site Scaling be enabled?."
  default     = false
  type        = bool
}
variable "zone_balancing_enabled" {
  description = "(Optional) Should the Service Plan balance across Availability Zones in the region"
  default     = false
  type        = bool 
}

#************************App Service Environment Variables *************************************
variable "appse_required" {
  description = "(Optional) enable app service environment?"
  type        = string
  default     = false
}
variable "appse_name" {
  description = "(Optional) The name of the App Service Environment"
  type        = string
  default     = null
}
variable "pricing_tier" {
  description = "(Optional) Pricing tier for the front end instances. Possible values are I1, I2 and I3"
  default     = "I1"
  type        = string
}
variable "front_end_scale_factor" {
  description = "(Optional) Scale factor for front end instances. Possible values are between 5 and 15"
  default     = 15
  type        = number
}
variable "internal_load_balancing_mode" {
  description = "(Optional) Specifies which endpoints to serve internally in the Virtual Network for the App Service Environment"
  default     = null
  type        = string
}
variable "allowed_user_ip_cidrs" {
  description = "(Optional) Allowed user added IP ranges on the ASE database"
  default     = null
  type        = list(string)
}
variable "subnet_id" {
  description = "(Optional) Azure subnet module output"
  type        = string
  default     = null
}
variable "cluster_setting" {
  description = "(Optional) store App Service Environment customizations"
  default     = null
  type        = object({
    name      = string
    value     = number
  })
}

#***************************** Linux Web App Variables ******************************************
variable "linux_web_app_required" {
  description = "(Optional) enable linux web app?"
  type        = string
  default     = false
}
variable "linux_webb_app_name" {
  description = "(Optional) The name which should be used for this Linux Web App"
  type        = string
  default     = null
}
variable "linux_tags" {
  description = "(Optional) Map of tags"
  type        = map
  default     = null
}
variable "https_only" {
  description = "(Optional)Disable http procotol and keep only https"
  type        = bool
  default     = true
}
variable "app_settings" {
  description = "App application settings"
  type        = map(any)
  default     = {}
}
variable "client_certificate_enabled" {
  description = "(Optional) Whether client certificate auth is enabled, default is false"
  default     = false
  type        = bool
}
variable "client_certificate_mode" {
  description = "(Optional) The option for client certificates"
  default     = "Optional"
  type        = string
}
variable "zip_deploy_file" {
  description = "(Optional) The local path and filename of the Zip packaged application to deploy to this Linux Web App."
  type        = string
  default     = null
}
variable "enabled" {
  description = "(Optional) Should the Linux Web App be enabled? "
  default     = true
  type        = bool
}
variable "settings" {
  description = "(Optional)Specifies the Authentication enabled or not"
  default     = false
  type        = any
}
variable "site_config" {
  description = "(Optional) Site config for App Service. IP restriction attribute is not managed in this block."
  type        = map(any)
  default     = {}
}
variable "storage_uses_managed_identity" {
  description = "(Optional) If you want the storage account to use a managed identity instead of a access key"
  default     = false
  type        = bool
}
variable "identity_ids" {
  description = "(Optional) Specifies a list of user managed identity ids to be assigned to the VM."
  type        = list(string)
  default     = []
}
variable "identity_type" {
  description = "(Optional) The Managed Service Identity Type of this Virtual Machine."
  type        = string
  default     = ""
}
variable "storage_account" {
  description = "(Optional) storage account parameters"
  type        = object({
    access_key     = string
      account_name = string
      name         = string
      share_name   = string
      type         = string
      mount_path   = string
  })
  default     = null 
}
variable "active_directory_auth_setttings" {
  description = "Active directory authentication provider settings for app service"
  type        = any
  default     = {}
}
variable "backup_sas_url" {
  description = "URL SAS to backup"
  type        = string
  default     = ""
}
variable "builtin_logging_enabled" {
  type        = bool
  description = "Whether AzureWebJobsDashboards should be enabled, default is true"
  default     = true
}
variable "connection_strings" {
  description = "Connection strings for App Service"
  type        = list(map(string))
  default     = []
}

#************************************ Linux App Slot Variables *****************************************
variable "linux_web_app_slot_required" {
  description = "(Optional) enable linux web app slot?"
  type        = string
  default     = false
}
variable "linux_web_app_slot_name" {
  description = "(Optional) name of the slot"
  type        = string
  default     = null
}
variable "auto_swap_slot_name" {
  description = "(Optional) The Linux Web App Slot Name to automatically swap to when deployment to that slot is successfully completed."
  type        = string
  default     = null  
}
#***************************** Windows Web App Variables ******************************************
variable "windows_web_app_required" {
  description = "(Optional) enable windows web app?"
  type        = string
  default     = false
}
variable "windows_webb_app_name" {
  description = "(Optional) Name of the windows web app"
  type        = string
  default     = null
}
variable "windows_tags" {
  description = "(Optional) Map of tags"
  type        = map
  default     = null
}
#************************************ Windows App Slot Variables *****************************************
variable "windows_web_app_slot_required" {
  description = "(Optional) enable web app slot"
  type        = string
  default     = false
}
variable "windows_web_app_slot_name" {
  description = "(Optional) name of the web app slot"
  type        = string
  default     = null
}
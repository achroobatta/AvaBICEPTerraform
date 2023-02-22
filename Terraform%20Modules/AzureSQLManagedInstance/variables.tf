variable "password_akv_id" {
  description = "(Required) AKV ID to be used with sql server to store the password"
  type = string
}

variable "password_akv_access_policy" {
  description = "(Required) Set dependency on the akv access policy used to manage the password"
  type = string
}

#******************************** Route Table Variables *********************************
variable "route_table_name" {
  description = "(Required) name of the route table"
  type        = string
}
variable "location" {
  description = "(Required) region of the storage acoount"
  type        = string
}
variable "resource_group_name" {
  description = "(Required) name of the resource group"
  type        = string
}
variable "subnet_id" {
  description = "(Required) Azure subnet module output"
  type        = string
}
variable "disable_bgp_route_propagation" {
  description = "(Optional) disable bgp route propagation"
  default     = false
  type        = bool
}

#********************* MSSQL Managed instance Variables *****************************************
variable "primary_instance_name" {
  description = "(Required) Name of the sql server. must not include non-alphanumeric characters"
  type        = string
}
variable "admin_username" {
  description = "(Required) admin_username"
  type = string
  default = "sqladmin"
  sensitive = true
}
variable "admin_password" {
  description = "(Required) admin_password"
  type = string
  default = null
  sensitive = true
}
variable "license_type" {
  description = "(Required) What type of license the Managed Instance will use. Valid values include can be PriceIncluded or BasePrice."
  type        = string
}
variable "sku_name" {
  description = "(Required) Specifies the SKU Name for the SQL Managed Instance."
  type        = string
}
variable "primary_instance_tags" {
  description = "(Required) map of tags"
  type        = map
}
variable "storage_size_in_gb" {
  description = "(Required) Maximum storage space for the SQL Managed instance. This should be a multiple of 32 (GB)."
  type        = number
}
variable "vcores" {
  description = "(Required) Number of cores that should be assigned to the SQL Managed Instance"
  type        = number
}
variable "collation" {
  description = "(Required) Specity the collation type required"
  default     = "SQL_Latin1_General_CP1_CI_AS"
  type        = string
}
variable "dns_zone_partner_id" {
  description = "(Optional) The ID of the SQL Managed Instance which will share the DNS zone."
  type        = string
  default     = null
}
variable "maintenance_configuration_name" {
  description = "(Optional) The name of the Public Maintenance Configuration window to apply"
  default     = null
  type        = string 
}
variable "minimum_tls_version" {
  description = "(Required) minimum transport layer security"
  type        = number
  default     = 1.2
}
variable "proxy_override" {
  description = "(Optional) Specifies how the SQL Managed Instance will be accessed"
  default     = "Default"
  type        = string
}
variable "public_data_endpoint_enabled" {
  description = "(Optional) Is the public data endpoint enabled?"
  default     = false
  type        = bool
}
variable "storage_account_type" {
  description = "(Optional) Specifies the storage account type used to store backups"
  default     = null
  type        = string
}
variable "timezone_id" {
    description = "(Optional) The TimeZone ID that the SQL Managed Instance will be operating in"
    default     = "UTC"
    type        = string
}
variable "identity" {
  description = "(Optional) identity block"
  default     = null
  type        = object({
    type = string
  })
}
variable "secondary_instance_name" {
  description = "(Optional) name of the secondary instance"
  type        = string
}
variable "secondary_instance_required" {
  description = "(Optional) secondary instance required?"
  type        = bool
  default     = false
}
variable "secondary_location" {
  description = "(Required) name of the secondary location"
  type        = string 
}
variable "secondary_instance_tags" {
  description = "(Required) map of tags for the secondary instance"
  type        = map
}

#******************** MSSQL Managed Instance Failover Group Variables *****************************
variable "failover_group_name" {
  description = "(Required) name for the failover group"
  type        = string
}
variable "readonly_endpoint_failover_policy_enabled" {
  description = "(Required) Whether failover is enabled for the readonly endpoint."
  default     = false
  type        = bool
}
variable "read_write_endpoint_failover_policy" {
  description = "(Required)The failover policy of the read-write endpoint for the failover group."
  type        = object({
    mode      = string // Automatic or Manual
    grace_minutes = number // only when the mode is set to automatic
  })
}

#*************************** Azure Monitor Onboarding ***********************************
variable "logging_retention" {
  description = "(Optional) Retention period of azure_monitor configuration"
  default = 30
  type    = number
}
variable "azure_monitor" {
  description = "(Required) Azure Monitor module output to configure monitoring"
  default = null
}
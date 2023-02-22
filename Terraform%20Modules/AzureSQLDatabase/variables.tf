variable "password_akv_id" {
  description = "(Required) AKV ID to be used with sql server to store the password"
  type = string
  default     = null
}

variable "password_akv_access_policy" {
  description = "(Required) Set dependency on the akv access policy used to manage the password"
  type = string
  default     = null
}

#****************************** SQL Server Variables *************************************************
variable "primary_sqlserver_name" {
  description = "(Required) Name of the sql server. must not include non-alphanumeric characters"
  type        = string
}
variable "secondary_sqlserver_name" {
  description = "(Required) Name of the sql server. must not include non-alphanumeric characters"
  default = null
  type        = string
}
variable "resource_group_name" {
  description = "(Required) name of the resource group"
  type        = string 
}
variable "location" {
  description = "(Required) location of the storage account"
  type        = string 
}
variable "secondary_sqlserver_location" {
  description = "(Required) location of the secondary server. Should be different to the primary server location"
  default = null
  type        = string 
}
variable "sqlserver_version" {
  description = " (Required) Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
  type        = string
  default     = "12.0"
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
variable "tags" {
  description = "(Required) map of tags "
  type        = map
}
variable "secondary_sqlserver_tags" {
  description = "(Required) map of tags"
  type        = map
  default = null
}
variable "minimum_tls_version" {
  description = "(Required) minimum transport layer security for sql dbs associated with the server"
  type        = number
  default     = "1.2"
}
variable "connection_policy" {
  description = "(Optional) server's connection policy setting - Default, Proxy or Redirect"
  type        = string
  default = "Default"
}
variable "public_network_access_enabled" {
  description = "(Optional) whether public network access is needed"
  type = bool
  default = false
}
variable "outbound_network_restriction_enabled" {
  description = "(Optional) whether outbound traffic from this server is resticted"
  type = bool
  default = false
}
variable "sqlid" {
  description = "(Optional) Managed identity for SQL server"
  default     = null
  type        = object({
    type      = string
    identity_ids = list(string)
  })
}
variable "sqlid_identity_ids" {
  description = "(Optional) list of user managed identities"
  default     = null
  type        = list(string) 
}
variable "sqlid_type" {
  description = "(Optional) Type of managed identity. Possible values: 'UserAssigned' or 'SystemAssigned'"
  default     = null
  type        = string
}
variable "primary_user_assigned_identity_id" {
  description = "(Optional) Specifies the primary user managed identity id. Required if type is UserAssigned"
  default     = null
  type        = string
}
variable "azuread_administrator" {
  description = "(Optional) If Azure AD authentication is needed"
  default     = null
  type        = object({
    login_username = string
    object_id      = string
    tenant_id      = string
    azuread_authentication_only = bool
  })
}
variable "dns_alias_names" {
  description = "(Optional) do you require dns alias?"
  type = list(string)
  default = null
}


#***************************** SQL Database *********************************************************
variable "db_names" {
  description = "(Required) names of the databases"
  type        = list(string)
}
variable "collation" {
  description = "(Required) Specity the collation type required"
  default     = "SQL_Latin1_General_CP1_CI_AS"
  type        = string
}
variable "license_type" {
  description = "(Optional) Specifies the license type applied to this database. Possible values: 'LicenseIncluded', 'BasePrice'"
  type        = string
  default     = null
}
variable "max_size_gb" {
  description = "(Required) Data size: min: 1gb, max: 1024 gb"
  type        = number
  default     = 10
}
variable "read_scale" {
  description = "(Optional) If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica. This property is only settable for Premium and Business Critical databases."
  default     = false
  type        = bool
}
variable "sku_name" {
  description = "(Required) Specifies the name of the SKU used by the database."
  #default = "S0"
  type        = string
  /*
  validation {
    condition = contains(["GP_S_Gen5_2", "HS_Gen4_1", "BC_Gen5_2", "ElasticPool", "Basic", "S0", "P2", "DW100c", "DS100"],var.sku_name)
    error_message = "Error: Selected sku is not valid, please check."
  }
  */
}
variable "zone_redundant" {
  description = "(Optional) Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
  default     = false
  type        = bool
}
variable "db_tags" {
  description = "(Required) map of tags "
  type        = map
}
variable "auto_pause_delay_in_minutes" {
  description = "(optional) Automatically pauses the database. min = 60: max = 10080 and -1 = autopause disabled"
  type        = number
  default = null
}
variable "create_mode" {
  description = "(Optional) The create mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup and Secondary"
  default     = null
  type        = string
}
variable "creation_source_database_id" {
  description = "(Optional) The ID of the source database from which to create the new database. This should only be used for databases with create_mode values."
  default     = null
  type        = string
}
variable "elastic_pool_id" {
  description = "(Optional) Specifies the ID of the elastic pool containing this database."
  default     = null
  type        = string
}
variable "geo_backup_enabled" {
  description = "(Optional) A boolean that specifies if the Geo Backup Policy is enabled. Only applicable for DataWarehouse SKUs. Ignored for all other SKUs."
  default     = null
  type        = bool
}
variable "ledger_enabled" {
  description = "(Optional) A boolean that specifies if this is a ledger database"
  default     = false
  type        = bool
  
}
variable "restore_point_in_time" {
  description = "(Optional) Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. This property is only settable for create_mode= PointInTimeRestore databases."
  default     = null
  type        = string
}
variable "recover_database_id" {
  description = "(Optional) The ID of the database to be recovered. This property is only applicable when the create_mode is Recovery."
  default     = null
  type        = string 
}
variable "restore_dropped_database_id" {
  description = "(Optional) The ID of the database to be restored. This property is only applicable when the create_mode is Restore."
  default     = null
  type        = string
}
variable "read_replica_count" {
  description = "(Optional) The number of readonly secondary replicas associated with the database. settable for Hyperscale edition databases."
  default     = null
  type        = number 
}
variable "sample_name" {
  description = "(Optional) Specifies the name of the sample schema to apply when creating this database"
  default     = null
  type        = string
}
variable "storage_account_type" {
  description = "(Optional) Specifies the storage account type used to store backups for this database. Possible values are Geo, GeoZone, Local and Zone. The default value is Geo."
  default     = null
  type        = string
}
variable "long_term_retention_policy" {
  description = "(Optional) long-term backup retention policy (LTR) to automatically retain backups in separate Azure Blob storage containers "
  default = null
  type        = object ({
    weekly_retention   = string
    monthly_retention  = string
    yearly_retention   = string
    week_of_year       = number
  })
}
variable "short_term_retention_policy" {
  description = "(Optional) Short term retention policy configuration"
  default     = null
  type        = object({
    retention_days = number
    backup_interval_in_hours = number
  })
}
variable "threat_detection_policy" {
  description = "(Optional) Threat detection policy configuration."
  default     = null
  type        = object({
    state                      = string // Enabled, Disabled or New
    disabled_alerts            = list(string) // Access_Anomaly, Sql_Injection & Sql_Injection_Vulnerability
    email_account_admins       = string
    email_addresses            = list(string)
    retention_days             = number
    storage_account_access_key = string
    storage_endpoint           = string
  })
}


#********************* Azure SQL Failover Group Variables ***************************
variable "failover_group_name" {
  description = "(Required) The name of the Failover Group. Changing this forces a new resource to be created."
  type        = string
  default     = null
}
variable "readonly_endpoint_failover_policy_enabled" {
  description = "(Optional) Whether failover is enabled for the readonly endpoint."
  default     = false
  type        = bool
}
variable "read_write_endpoint_failover_policy" {
  description = "(Required)The failover policy of the read-write endpoint for the failover group."
  type        = object({
    mode      = string // Automatic or Manual
    grace_minutes = number // only when the mode is set to automatic
  })
  default = {
    grace_minutes = 60
    mode = "Automatic"
  }
}
variable "failover_group_tags" {
  description = "(Required) map of tags "
  type        = map
  default     = null
}
#************************* Elastic Pool Variables ****************************************
variable "elastic_pool_name" {
  description = "(Required) The name of the elastic pool. This needs to be globally unique."
  type        = string
  default     = null
}
variable "elastic_pool_licence_type" {
  description = "(Optional) Specifies the license type applied to this database. Possible values are 'LicenseIncluded' and 'BasePrice'."
  type        = string 
  default     = null
}
variable "elastic_pool_max_size_gb" {
  description = "(Optional) The max data size of the elastic pool in gigabytes."
  default     = null
  type        = number
}
variable "elastic_pool_sku" {
  description = "(Required) sku of the elastic pool"
  type        = object({
    name      = string
    capacity  = number // The scale up/out capacity, representing server's compute units. 
    tier      = string
    //family    = string
  })
  default     = null 
}
variable "per_database_settings" {
  description = "(Required) min & max database capacities"
  type        = object({
    min_capacity = number
    max_capacity = number
  })
  default     = null
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
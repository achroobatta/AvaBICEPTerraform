variable "name" {
  description = "(Required) Name of the storage account"
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
variable "tags" {
  description = "(Required) map of tags "
  type        = map
}
variable "storage_account_tier" {
  description = "(Required) tier for the storage account. Accepted values are Standard, Premium"
  type        = string
  default     = "Standard"
}
variable "storage_account_kind" {
  description = "(Required) Storage account kind. Accepted values are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  type        = string
  default     = "StorageV2"
}
variable "storage_account_replication_type" {
  description = "(Required) Storage account replication type. Accepted values are LRS, ZRS, GRS, GZRS"
  type        = string
  default     = "LRS"
  validation {
    condition = contains(["LRS", "ZRS", "GRS", "GZRS"],var.storage_account_replication_type)
    error_message = "Error: replication type not valid!!"
  }
}
variable "enable_advanced_threat_protection" {
  description = "(Otional) Boolean flag which controls if advanced threat protection is enabled."
  default     = false
  type        = bool
}
variable "storage_account_access_tier" {
  description = "(Required) Access tier for Storagev2, BlobStorage, FileStorage. Valid options are Hot and Cool."
  type        = string
  default     = "Hot"
}
variable "cross_tenant_replication_enabled" {
  description = "(Optional) should you have cross Tenant replication?"
  type        = bool
  default     = false
}

variable "min_tls_version" {
  description = "(Optional) Version of the Transport Security Layer(tls)"
  type        = string
  default     = "TLS1_2"
}
 
variable "shared_access_key_enabled" {
  description = "(Optional) Enable requests to storage account via Shared Key"
  default     = true
  type        = bool
}
variable "is_hns_enabled" {
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2"
  type        = bool
  default     = false
}
variable "nfsv3_enabled" {
  description = "(Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created." 
  type        = bool
  default     = false
}
variable "large_file_share_enabled" {
  description = "(Optional) do we need large file share enabled?"
  type        = bool
  default = false 
}
variable "queue_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Possible values are 'Service' & 'Account'"
  type        = string
  default     = "Service"
}
variable "table_encryption_key_type" {
  description = "(Optional) The encryption type of the queue service. Possible values are 'Service' & 'Account'"
  type        = string
  default     = "Service"
}
variable "infrastructure_encryption_enabled" {
  description = "(Optional) do we need encryption for infrastructure enabled?"
  type        = bool
  default     = false
}
variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned. Possible values are 'SystemAssigned', 'UserAssigned' and 'SystemAssigned, UserAssigned'"
  default     = null
  type        = string
}
variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned."
  default     = null
  type        = list(string)
}

variable "blob_soft_delete_retention_days" {
  description = "(Optional)Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}
variable "container_soft_delete_retention_days" {
  description = "(optional)Specifies the number of days that the blob should be retained, between `1` and `365` days. Defaults to `7`"
  default     = 7
  type        = number
}
variable "cors_rule" {
  description = "All the below parameters are required for blob CORS rule "
  type = object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    exposed_headers = list(string)
    max_age_in_seconds = number
    })
  default = null
}
variable "enable_versioning" {
  description = "Is versioning enabled? Default to `false`"
  default     = false
  type        = bool
}
variable "last_access_time_enabled" {
  description = "(optional)Is the last access time based tracking enabled? Default to `false`"
  default     = false
  type        = bool
}
variable "change_feed_enabled" {
  description = "(optional)provide transaction logs of all the changes that occur to the blobs & the blob metadata in your storage account"
  default     = false
  type        = bool
}
variable "default_service_version" {
  description = "(Optional) The API Version which should be used by default for requests to the Data Plane API if an incoming request doesn't specify an API Version"
  type        = string
  default     = "2020-06-12"
}
variable "queue_cors_rule" {
  description = "(Optional)All the below parameters are required for queue CORS rule "
  type = object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    exposed_headers = list(string)
    max_age_in_seconds = number
    })
  default = null
}
variable "queue_logging" {
  description = "(Optional)Looging parameters to configure for queues"
  type = object({
    delete                = bool
    read                  = bool
    version               = string
    write                 = bool
    retention_policy_days = number
  })
  default = null
}
variable "queue_minute_metrics" {
  description = "(Optional)Queue minute metrics parameters to configure"
  type = object({
    enabled               = bool
    version               = string
    include_apis          = bool
    retention_policy_days = number
  })
  default = null
}
variable "queue_hour_metrics" {
  description = "(Optional)Queue hour metrics parameters to configure"
  type = object({
    enabled               = bool
    version               = string
    include_apis          = bool
    retention_policy_days = number
  })
  default = null
}
variable "share_retention_days" {
  description = "(Optional) Specifies the number of days that the azurerm_storage_share should be retained."
  type        = number
  default     = null
}
variable "share_cors_rule" {
  description = "(Optional)All the below parameters are required for queue CORS rule "
  type = object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    exposed_headers = list(string)
    max_age_in_seconds = number
  })
  default = null
}
variable "share_smb" {
  description = "smb block parameters to configure"
  type = object({
    versions = string
    authentication_types = string
    kerberos_ticket_encryption_type = string
    channel_encryption_type = string
  })
  default = null
}
variable "network_rules" {
  description = "Network rules restricing access to the storage account."
  type        = object({ 
    bypass = list(string), 
    ip_rules = list(string), 
    virtual_network_subnet_ids = list(string) 
  })
  default     = null
}

variable "private_link_access" {
  description = "private link access to the storage account."
  type        = list(object({ 
    endpoint_resource_id = string
    endpoint_tenant_id = string
  }))
  default     = null
}

variable "custom_domain" {
  description = "(Optional) specify custom domain name"
  type        = object({
    name      = string
    use_subdomain = bool
  })
  default = null
}
variable "customer_managed_key" {
  description = "(Optional) specify customer managed key"
  type        = object({
    key_vault_key_id = string
    user_assigned_identity_id = string
  })
  default = null
}
variable "routing" {
  description = "configure routing requirements"
  type        = object({
    publish_internet_endpoints  = bool
    publish_microsoft_endpoints = bool
    choice                      = string // options are InternetRouting and MicrosoftRouting
  })
  default = null
}
variable "azure_files_authentication" {
  description = "(Optional) azure files authentication type"
   type   = any
   default     = null
}
variable "active_directory" {
  type =  object({
    storage_sid = string
    domain_name = string
    domain_sid  = string
    domain_guid = string
    forest_name = string
    netbios_domain_name = string
  })
  default = null
}
variable "containers_list" {
  description = "(Required)List of containers to create and their access levels."
  type        = list(object({ name = string, access_type = string }))
  default     = []
}
variable "file_shares" {
  description = "(Required)List of containers to create and their access levels."
  type        = list(object({ name = string, quota = number }))
  default     = []
}
variable "tables" {
  description = "(Required)List of storage tables."
  type        = list(string)
  default     = []
}
variable "queues" {
  description = "(Required)List of storages queues"
  type        = list(string)
  default     = []
}
variable "logging_retention" {
  description = "(Optional) Retention period of azure_monitor configuration"
  default = 30
  type    = number
}
variable "azure_monitor" {
  description = "(Required) Azure Monitor module output to configure monitoring"
  default = null
}
variable "static_website" {
  description          = ("(Optional)host a static website in azure blob storage")
  type                 = object({
    index_document     = string # The webpage that Azure Storage serves for requests to the root of a website or any subfolder
    error_404_document = string # The absolute path to a custom webpage that should be used when a request is made which does not correspond to an existing file.
  })
  default = null
}

variable "allow_nested_items_to_be_public" {
  description = "(Optional) Boolean flag which allow_nested_items_to_be_public."
  default     = false
  type        = bool
}

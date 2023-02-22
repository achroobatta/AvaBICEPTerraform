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

variable "network_security_group_names" {
  description = "(Required) NSG name that the AADDS is affected by, pass output of the NSG resource provider instead of string for implicit dependency"
  type=list(string)
}

variable "admin_upn" {
  description = "(Required) userprincipalname of the admin user to be created"
  type=string
}

variable "domain_name" {
  description = "(Required) domain name of aadds"
  type=string
}


variable "subnet_id" {
  description = "(Required) subnet_id to attach the aadds"
  type=string
}

variable "use_random_password" {
  description = "(Required) use random password"
  type        = bool
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

variable "password_akv_id" {
  description = "(Optional) Required when relying on random generated password, AKV ID to be used with VM to store the password"
  type = string
  default = null
}

variable "password_akv_access_policy" {
  description = "(Optional) Required when relying on random generated password, Set dependency on the akv access policy used to manage the password"
  type = string
  default = null
}

variable "admin_password" {
  description = "(Optional) define the admin user password to be created. Random complex password will be generated if left empty"
  type = string
  default = null
}

variable "sku" {
  description = "(Optional) refer to active_directory_domain)service for usage"
  type = string
  default = "Standard"
}

variable "filtered_sync_enabled" {
  description = "(Optional) refer to active_directory_domain)service for usage"
  type = bool
  default = false
}

variable "notifications" {
  description = "(Optional)notifications block, refer to active_directory_domain_service for usage"
  type = object({
    additional_recipients = list(string)
    notify_dc_admins      = bool
    notify_global_admins  = bool
  })
  default = null
}

variable "secure_ldap" {
  description = "(Optional)secure_ldap block, refer to active_directory_domain)service for usage. A sensitive variable"
  type = object({
    enabled = bool
    external_access_enabled = bool
    pfx_certificate = any
    pfx_certificate_password = any
  })
  default = null
  sensitive = true
}

variable "security" {
  description = "(Optional)security block, refer to active_directory_domain)service for usage. A sensitive variable"
  type = object({
    sync_kerberos_passwords = bool
    sync_ntlm_passwords     = bool
    sync_on_prem_passwords  = bool
    ntlm_v1_enabled = bool
    tls_v1_enabled = bool
  })
  default = null
  sensitive = true
}
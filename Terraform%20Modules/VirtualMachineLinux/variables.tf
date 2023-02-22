#Require variables###############################################################################
variable "name" {
  description = "(Required) Name of the vm"
  type        = string
}

variable "location" {
  description = "(Required) Define the region where the resource will be created"
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where to create the vm"
  type        = string
}

variable "size" {
  description = "(Required) Size of the vm"
  type        = string
}

variable "tags" {
  description = "(Required) map of tags for the deployment"
  type        = map
}

variable "vm_nics" {
  description = "(Required) vm_nics configuration list"
  type=list(object({
    subnet_id=string
    public_ip_address_id=string
    private_ip_address=string
    private_ip_address_version=string
  }))

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

variable "vmrestored" {
  description = "(Optional) Have this VM been restore?"
  type = bool
  default = false
}

variable "data_disks" {
  description = "(Optional) Data disks to create and attach"
  type=list(object({
    name=string
    size=string
  }))
  default = []
}

variable "admin_username" {
  description = "(Optional) admin_username"
  type = string
  default = "linadmin"
  sensitive = true
}

variable "admin_password" {
  description = "(Optional) admin_password"
  type = string
  default = null
  sensitive = true
}

variable "admin_ssh_key" {
  description = "(Optional) Have this VM been restore?"
  type = any
  default = null
  sensitive = true
}

variable "disable_password_authentication" {
  description = "(Optional) refer to VM resource provider for usage"
  type=bool
  default = false
  
}

variable "license_type" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}

variable "vtpm_enabled" {
  description = "(Optional) refer to VM resource provider for usage"
  type=bool
  default = null
}

variable "secure_boot_enabled" {
  description = "(Optional) refer to VM resource provider for usage"
  type=bool
  default = null
}

variable "encryption_at_host_enabled" {
  description = "(Optional) refer to VM resource provider for usage"
  type=bool
  default = null
}

variable "availability_set_id" {
  description = "(Optional) Used for VM Availability set config"
  type=string
  default = null
}

variable "zone" {
  description = "(Optional) Used for VM Availability zone config"
  type=string
  default = null
}

variable "dedicated_host_id" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}

variable "dedicated_host_group_id" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}

variable "proximity_placement_group_id" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}

variable "edge_zone" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}

variable "capacity_reservation_group_id" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}


variable "provision_vm_agent" {
  description = "(Optional) refer to VM resource provider for usage"
  type = bool
  default = true
}

variable "patch_mode" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}

variable "allow_extensions_operations" {
  description = "(Optional) refer to VM resource provider for usage"
  type=bool
  default = null
}

variable "extensions_time_budget" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = "PT1H30M"
}

variable "termination_notification_timeout" {
  description = "(Optional) refer to VM resource provider for usage for timeout parameter in termination_notification block"
  type=number
  default = null
}

variable "secret_key_vault_id" {
  description = "(Optional) refer to VM resource provider for usage for vault_id parameter in secret block"
  type=string
  default = null
}

variable "certificates" {
  description = "(Optional) refer to VM resource provider for usage for certificate block"
  type = list(object({
    url = string
  }))
  default = null
}


variable "priority" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}

variable "max_bid_price" {
  description = "(Optional) refer to VM resource provider for usage"
  type=number
  default = null
}

variable "eviction_policy" {
  description = "(Optional) refer to VM resource provider for usage"
  type=string
  default = null
}


variable "source_image_reference" {
  description = "(Optional) Source Image Reference, cannot be used together with source_image_id, but at least one must be defined"
  type=object({
    offer     = string
    publisher = string
    sku       = string
    version   = string
  })
  default = {
  offer     = null
    publisher = null
    sku       = null
    version   = null
}
}

variable "source_image_id" {
  description = "(Optional) Source Image id, cannot be used together with source_image_reference, but at least one must be defined"
  type=string
  default = null
}

variable "plan" {
  description = "(Optional) plan block"
  type=object({
    name     = string
    product = string
    publisher = string
  })
  default = {
    name     = null
    product = null    
    publisher = null
}
}

variable "identity" {
  description = "(Optional) identity block"
  type=object({
    type = string
    identity_ids = list(string)
  })
  default = {
    type = null
    identity_ids = null
}
}


variable "ultra_ssd_enabled" {
  description = "(Optional) enable ultra_ssd"
  type=bool
  default = false
}

variable "os_disk" {
  description = "(Optional) os_disk"
  type=object({
    caching           = string
    storage_account_type = string
    disk_size_gb = string
    write_accelerator_enabled = string
    disk_encryption_set_id = string
    security_encryption_type = string
    secure_vm_disk_encryption_set_id = string
    diff_disk_settings = object({
      option = string
      placement = string
    })
  })
  default = {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = null
    write_accelerator_enabled = null
    disk_encryption_set_id = null
    security_encryption_type = null
    secure_vm_disk_encryption_set_id = null
    diff_disk_settings = {
      option = null
      placement = null
    }
  }
}
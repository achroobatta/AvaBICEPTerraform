#generate random password, will be populated into local
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#create password secret
resource "azurerm_key_vault_secret" "vmadmin" {
  count = var.use_random_password ? 1 :0
  name         = var.name
  value        = local.admin_password
  key_vault_id = var.password_akv_id
  depends_on = [
    var.password_akv_access_policy
  ]
}

#vmnic(s)
resource "azurerm_network_interface" "vmnics" {
  count= length(var.vm_nics)
  name                = "${var.name}-vnic${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  edge_zone = var.edge_zone

  ip_configuration {
    name                          = "${var.name}-ipconfig${count.index}"
    subnet_id                     = var.vm_nics[count.index].subnet_id
    private_ip_address_version = var.vm_nics[count.index].private_ip_address_version
    #Set IP address allocation based on presence of IP address
    private_ip_address_allocation = var.vm_nics[count.index].private_ip_address != null ? "Static" : "Dynamic"
    private_ip_address = var.vm_nics[count.index].private_ip_address
    public_ip_address_id = var.vm_nics[count.index].public_ip_address_id
  }
}

#create vm
resource "azurerm_windows_virtual_machine" "vm" {
  name                  = var.name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = azurerm_network_interface.vmnics[*].id
  size               = var.size
  admin_username = var.admin_username
  #Use random generated password if use_random_password is true
  admin_password = var.use_random_password ==false ? var.admin_password:local.admin_password
  computer_name  = var.name
  license_type = var.license_type

  #security configs
  vtpm_enabled = var.vtpm_enabled
  encryption_at_host_enabled = var.encryption_at_host_enabled
  secure_boot_enabled = var.secure_boot_enabled

  #HA and VM placement configs 
  availability_set_id= var.availability_set_id
  zone = var.zone
  dedicated_host_id = var.dedicated_host_id
  dedicated_host_group_id = var.dedicated_host_group_id
  proximity_placement_group_id = var.proximity_placement_group_id
  edge_zone = var.edge_zone
  capacity_reservation_group_id = var.capacity_reservation_group_id


  #agent and vm management configs
  provision_vm_agent        = var.provision_vm_agent
  enable_automatic_updates = var.enable_automatic_updates
  hotpatching_enabled = var.hotpatching_enabled
  patch_mode = var.patch_mode
  allow_extension_operations = var.allow_extensions_operations
  extensions_time_budget = var.extensions_time_budget

  termination_notification {
    #set enable based on var.termination_notification_timeout has value
    enabled = var.termination_notification_timeout != null ? true: false
    timeout = var.termination_notification_timeout
  }

  #optional winrm_listener block
  dynamic "winrm_listener" {
    for_each = var.winrm_listener_certificate_url != null ? [true]:[]
    content {
      protocol = "Https"
      certificate_url = var.winrm_listener_certificate_url
    }
  }

  #optional nested dynamic block for secret and certificate blocks
  dynamic "secret" {
    for_each = var.secret_key_vault_id != null ? [true]:[]
    content {
      key_vault_id  = secret_key_vault_id
      dynamic "certificate" {
        #code is expected to fail if it is null as certificate is a required block, therefore no checks are done
        for_each = var.certificates
        content {
          url = certificate.value.url
          store = certificate.value.store
        }
      }
    }
  }

  #spot pricing
  priority = var.priority
  max_bid_price = var.max_bid_price
  eviction_policy = var.eviction_policy

  #image management
  source_image_id = var.source_image_id
  #optional image reference block
  dynamic "source_image_reference" {
    for_each = var.source_image_reference.offer != null ? [true]:[]
    content {
    offer     = var.source_image_reference.offer
    publisher = var.source_image_reference.publisher
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
    }
  }
  #optional plan block
  dynamic "plan" {
    for_each = var.plan.name != null ? [true]:[]
    content {
    name = var.plan.name
    product =var.plan.product
    publisher = var.plan.publisher
    }
  }

  #optional identity block
  dynamic "identity" {
    for_each = var.identity.type != null ? [true]:[]
    content {
      type = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }


  #os disk
  os_disk {
    caching           = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb = var.os_disk.disk_size_gb
    write_accelerator_enabled = var.os_disk.write_accelerator_enabled
    disk_encryption_set_id = var.os_disk.disk_encryption_set_id
    security_encryption_type = var.os_disk.security_encryption_type
    secure_vm_disk_encryption_set_id = var.os_disk.secure_vm_disk_encryption_set_id
    #optional diff_disk_settings block
    dynamic "diff_disk_settings" {
    for_each = var.os_disk.diff_disk_settings.option != null ? [true]:[]
    content {
      option = var.os_disk.diff_disk_settings.option
      placement = var.os_disk.diff_disk_settings.placement
    }
  }
  }

  #optional enabling of ultra ssd
  dynamic "additional_capabilities" {
    for_each = var.ultra_ssd_enabled ? [true]:[]
    content {
      ultra_ssd_enabled = true
    }
  }
  #optional boot diagnostics depending if storage account exist in Azure monitor
  dynamic "boot_diagnostics" {
    for_each = length(var.azure_monitor.sa_out) > 0 ? [true]:[]
    content {
      storage_account_uri = var.azure_monitor.sa_out[0].primary_blob_endpoint
    }
  }

  #optional additional_unattend_content
  dynamic "additional_unattend_content" {
    for_each = var.additional_unattend_content.content != null ? [true]:[]
    content {
      content = var.additional_unattend_content.content
      setting = var.additional_unattend_content.setting
    }
  }
 
  tags = var.tags
}

#create data disk(s)
resource "azurerm_managed_disk" "disks" {
  count = var.vmrestored ? 0:length(var.data_disks)
  name="${var.name}-${var.data_disks[count.index].name}"
  location             = var.location
  resource_group_name  = var.resource_group_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.data_disks[count.index].size
  tags     = var.tags
  #inherited settings
  zone = var.zone
  edge_zone = var.edge_zone
  disk_encryption_set_id = var.os_disk.disk_encryption_set_id
}

#attach each disk(s) to the VM
resource "azurerm_virtual_machine_data_disk_attachment" "disksattach" {
  count = var.vmrestored ? 0: length(var.data_disks)
  managed_disk_id    = azurerm_managed_disk.disks[count.index].id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = count.index+10
  caching            = "ReadWrite"
}

#nic logging for each nic
module "vmnics_diag" {
  count = var.azure_monitor != null ? length(var.vm_nics) : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_network_interface.vmnics[count.index].name
  resource_id                = azurerm_network_interface.vmnics[count.index].id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name",  "Diagnostics Enabled", "Retention Enabled", Retention period] 
    ]
    metric = [
      ["AllMetrics", true, var.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}
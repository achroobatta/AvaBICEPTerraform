#create required nsgs
resource "azurerm_network_security_rule" "AllowSyncWithAzureAD" {
  for_each = toset(var.network_security_group_names)
  network_security_group_name = each.value
  name                        = "AllowSyncWithAzureAD"
  priority                    = 3000
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "AzureActiveDirectoryDomainServices"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "AllowRD" {
  for_each = toset(var.network_security_group_names)
  network_security_group_name = each.value
  name                        = "AllowRD"
  priority                    = 3001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "CorpNetSaw"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "AllowPSRemoting" {
  for_each = toset(var.network_security_group_names)
  network_security_group_name = each.value
  name                        = "AllowPSRemoting"
  priority                    = 3002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5986"
  source_address_prefix       = "AzureActiveDirectoryDomainServices"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
}

resource "azurerm_network_security_rule" "AllowLDAPS" {
  for_each = toset(var.network_security_group_names)
  network_security_group_name = each.value
  name                        = "AllowLDAPS"
  priority                    = 3003
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "636"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
}

#create admin group
resource "azuread_group" "dc_admins" {
  display_name     = "AAD DC Administrators"
  security_enabled = true
}

#generate random password, will be populated into local
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#create password secret
resource "azurerm_key_vault_secret" "vmadmin" {
  count = var.use_random_password ? 1 :0
  #remove special characters in a UPN as it is not allowed as name in AKV
  name         = regex("[0-9A-Za-z]+" , var.admin_upn)
  #If no password is defined, use random generated password
  value        = var.admin_password != null ? var.admin_password:local.admin_password
  key_vault_id = var.password_akv_id
  depends_on = [
    var.password_akv_access_policy
  ]
}

#create admin user
resource "azuread_user" "admin" {
  user_principal_name = var.admin_upn
  display_name        = "DC Administrator"
  password            = var.use_random_password == false ? var.admin_password:local.admin_password
}

#create spn for aadds
resource "azuread_service_principal" "aaddsspn" {
  application_id = "2565bd9d-da50-47d4-8b85-4c97f669dc36" // published app for domain services
}

#provision aadds
resource "azurerm_active_directory_domain_service" "aadds" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  domain_name           = var.domain_name
  sku                   = var.sku
  filtered_sync_enabled = var.filtered_sync_enabled

  initial_replica_set {
    subnet_id = var.subnet_id
  }
  
  #dynamic block for notifications block
  dynamic "notifications" {
    for_each = var.notifications != null ? [true] : []
    content {
    additional_recipients = var.notifications.additional_recipients
    notify_dc_admins      = var.notifications.notify_dc_admins
    notify_global_admins  = var.notifications.notify_dc_admins
    }
  }

  #dynamic block for secure_ldap block
  dynamic "secure_ldap" {
    for_each = var.secure_ldap != null ? [true] : []
    content {
    enabled = var.secure_ldap.enabled
    external_access_enabled = var.secure_ldap.external_access_enabled
    pfx_certificate = var.secure_ldap.pfx_certificate
    pfx_certificate_password = var.secure_ldap.pfx_certificate_password
    }
  }
  security {
    sync_kerberos_passwords = true
    sync_ntlm_passwords     = true
    sync_on_prem_passwords  = true
  }


  #dynamic block for security block
  dynamic "security" {
    for_each = var.security != null ? [true] : []
    content {
    sync_kerberos_passwords = var.security.sync_kerberos_passwords
    sync_ntlm_passwords     = var.security.sync_ntlm_passwords
    sync_on_prem_passwords  = var.security.sync_on_prem_passwords
    ntlm_v1_enabled = var.security.ntlm_v1_enabled
    tls_v1_enabled = var.security.tls_v1_enabled
    }
  }

  tags = var.tags

  depends_on = [
    azuread_service_principal.aaddsspn,
    azurerm_network_security_rule.AllowLDAPS,
    azurerm_network_security_rule.AllowPSRemoting,
    azurerm_network_security_rule.AllowRD,
    azurerm_network_security_rule.AllowSyncWithAzureAD
  ]
}


#logging for aadds
module "aadds_diag" {
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_active_directory_domain_service.aadds.name
  resource_id                = azurerm_active_directory_domain_service.aadds.resource_id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["SystemSecurity", true, var.logging_retention],
      ["AccountManagement", true, var.logging_retention],
      ["LogonLogoff", true, var.logging_retention],
      ["ObjectAccess", true, var.logging_retention],
      ["PolicyChange", true, var.logging_retention],
      ["PrivilegeUse", true, var.logging_retention],
      ["DetailTracking", true, var.logging_retention],
      ["DirectoryServiceAccess", true, var.logging_retention],
      ["AccountLogon", true, var.logging_retention],
    ]
    metric = [
      ["AllMetrics", true, true, var.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}
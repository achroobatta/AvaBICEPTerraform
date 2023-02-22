
#generate random password, will be populated into local
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#create password secret
resource "azurerm_key_vault_secret" "vmadmin" {
  count = var.admin_password == null ? 1 : 0
  name  = var.primary_instance_name
   
    #If no password is defined, use random generated password
  value        = var.admin_password != null ? var.admin_password:local.admin_password
  key_vault_id = var.password_akv_id
  depends_on = [
    var.password_akv_access_policy
  ]
}
#********************************** Route Table ***********************************************
resource "azurerm_route_table" "rtable" {
  name                          = var.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  disable_bgp_route_propagation = var.disable_bgp_route_propagation
  
}

resource "azurerm_subnet_route_table_association" "rt_association" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.rtable.id
}

#***************************** Primary MSSQL Managed Instance******************************************
resource "azurerm_mssql_managed_instance" "primary" {
  name                = var.primary_instance_name
  resource_group_name = var.resource_group_name
  location            = var.location
  license_type        = var.license_type
  sku_name            = var.sku_name
  tags                = var.primary_instance_tags
  storage_size_in_gb  = var.storage_size_in_gb
  subnet_id           = var.subnet_id
  vcores              = var.vcores
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password != null ? var.admin_password:local.admin_password
  collation            = var.collation
  dns_zone_partner_id  = var.dns_zone_partner_id
  maintenance_configuration_name = var.maintenance_configuration_name
  minimum_tls_version  = var.minimum_tls_version
  proxy_override       = var.proxy_override
  public_data_endpoint_enabled = var.public_data_endpoint_enabled
  storage_account_type = var.storage_account_type
  timezone_id          = var.timezone_id
  
  dynamic "identity" {
    for_each = var.identity != null ? ["true"] : []
    content {
        type = var.identity.type
    }
  }
}

#***************************** Secondary MSSQL Managed Instance ********************************
resource "azurerm_mssql_managed_instance" "secondary" {
  count = var.secondary_instance_required ? 1 : 0
  name                = var.secondary_instance_name
  resource_group_name = var.resource_group_name
  location            = var.secondary_location
  license_type        = var.license_type
  sku_name            = var.sku_name
  tags                = var.secondary_instance_tags
  storage_size_in_gb  = var.storage_size_in_gb
  subnet_id           = var.subnet_id
  vcores              = var.vcores
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password != null ? var.admin_password:local.admin_password
  collation            = var.collation
  minimum_tls_version  = var.minimum_tls_version
}

#********************* MSSQL Managed Instance Failover Group ***************************************
resource "azurerm_mssql_managed_instance_failover_group" "failover" {
  name                        = var.failover_group_name
  location                    = azurerm_mssql_managed_instance.primary.location
  managed_instance_id         = azurerm_mssql_managed_instance.primary.id
  partner_managed_instance_id = azurerm_mssql_managed_instance.secondary[0].id
  readonly_endpoint_failover_policy_enabled  = var.readonly_endpoint_failover_policy_enabled
  read_write_endpoint_failover_policy {
    mode = var.read_write_endpoint_failover_policy.mode
    grace_minutes = var.read_write_endpoint_failover_policy.grace_minutes
  }
}

#*********************** Azure Monitor Onboarding ***************************************

module "managed_instance_diag" {
  source                     = "../AzureMonitorOnboarding/"
  count = var.azure_monitor != null ? 1 : 0
  resource_name              = azurerm_mssql_managed_instance_failover_group.failover.name
  resource_id                = azurerm_mssql_managed_instance_failover_group.failover.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["SQLInsights", true, var.logging_retention],
      ["QueryStoreRuntimeStatistics", true, var.logging_retention],
      ["Errors", true, var.logging_retention],
      ["QueryStoreWaitStatistics", true, var.logging_retention],
    ]
    metric = [
      ["avg_cpu_percent", true, var.logging_retention],
      ["storage_space_used_mb", true, var.logging_retention]
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}

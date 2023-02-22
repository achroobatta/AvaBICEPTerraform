#generate random password, will be populated into local
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#create password secret
resource "azurerm_key_vault_secret" "vmadmin" {
  count = var.admin_password == null ? 1 : 0
  name  = var.primary_sqlserver_name 
   
    #If no password is defined, use random generated password
  value        = var.admin_password != null ? var.admin_password:local.admin_password
  key_vault_id = var.password_akv_id
  depends_on = [
    var.password_akv_access_policy
  ]
}
#******************************* Azure SQL Server ************************************************
resource "azurerm_mssql_server" "primary" {
  name                         = var.primary_sqlserver_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sqlserver_version
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password != null ? var.admin_password:local.admin_password
  minimum_tls_version          = var.minimum_tls_version
  tags                         = var.tags
  connection_policy            = var.connection_policy
  public_network_access_enabled = var.public_network_access_enabled
  outbound_network_restriction_enabled = var.outbound_network_restriction_enabled
  primary_user_assigned_identity_id = var.sqlid_type == "UserAssigned" ? var.primary_user_assigned_identity_id : null
  dynamic "identity" {
    for_each = var.sqlid != null ? ["true"] : []
    content {
      type         = var.sqlid_type
      identity_ids = var.sqlid_type == "UserAssigned" ? var.sqlid_identity_ids : null
    }
  }
  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator != null ? ["true"] : []
    content {
      login_username = var.azuread_administrator.login_username
      object_id      = var.azuread_administrator.object_id
      tenant_id      = var.azuread_administrator.tenant_id
      azuread_authentication_only = var.azuread_administrator.azuread_authentication_only
    } 
  }
}
resource "azurerm_mssql_server" "secondary" {
  count = var.secondary_sqlserver_name != null ? 1 : 0
  name                         = var.secondary_sqlserver_name
  resource_group_name          = var.resource_group_name
  location                     = var.secondary_sqlserver_location
  version                      = var.sqlserver_version
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password != null ? var.admin_password:local.admin_password
  tags                         = var.secondary_sqlserver_tags
}
#Manages a MS SQL Server DNS Alias.
resource "azurerm_mssql_server_dns_alias" "primary" {
  count = var.dns_alias_names != null ? length (var.dns_alias_names) : 0
  name            = var.dns_alias_names[count.index]
  mssql_server_id = azurerm_mssql_server.primary.id
}

#**************************** SQL Database ***************************************************
resource "azurerm_mssql_database" "sqldb" {
  count = var.db_names != null ? length (var.db_names) : 0
  name           = var.db_names[count.index]
  server_id      = azurerm_mssql_server.primary.id
  collation      = var.collation
  license_type   = var.license_type
  max_size_gb    = var.max_size_gb
  read_scale     = var.read_scale
  sku_name       = var.sku_name
  zone_redundant = var.zone_redundant
  tags           = var.db_tags 
  auto_pause_delay_in_minutes = var.auto_pause_delay_in_minutes
  create_mode    = var.create_mode
  creation_source_database_id = var.creation_source_database_id == var.create_mode != null ? var.creation_source_database_id : null
  elastic_pool_id = var.elastic_pool_id
  geo_backup_enabled = var.geo_backup_enabled
  ledger_enabled  = var.ledger_enabled
  restore_point_in_time = var.restore_point_in_time == var.create_mode == "PointInTimeRestore" ? var.restore_point_in_time : null 
  recover_database_id = var.recover_database_id == var.create_mode == "Recovery" ? var.recover_database_id : null
  restore_dropped_database_id = var.restore_dropped_database_id == var.create_mode == "Recovery" ? var.restore_dropped_database_id : null
  read_replica_count = var.read_replica_count
  sample_name     = var.sample_name 
  storage_account_type = var.storage_account_type
   dynamic "long_term_retention_policy" {
    for_each = var.long_term_retention_policy != null ? ["true"] : []
    content {
      weekly_retention  = var.long_term_retention_policy.weekly_retention
      monthly_retention = var.long_term_retention_policy.monthly_retention
      yearly_retention  = var.long_term_retention_policy.yearly_retention
      week_of_year      = var.long_term_retention_policy.week_of_year
    }
  }
  dynamic "short_term_retention_policy" {
    for_each = var.short_term_retention_policy != null ? ["true"] : []
    content {
      retention_days = var.short_term_retention_policy.retention_days
      backup_interval_in_hours = var.short_term_retention_policy.backup_interval_in_hours
    }
  }
  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy != null ? ["true"] :[]
    content {
    state                      = var.threat_detection_policy.state
    disabled_alerts            = var.threat_detection_policy.disabled_alerts
    email_account_admins       = var.threat_detection_policy.email_account_admins
    email_addresses            = var.threat_detection_policy.email_addresses
    retention_days             = var.threat_detection_policy.retention_days
    storage_account_access_key =  var.threat_detection_policy.storage_account_access_key
    storage_endpoint           = var.threat_detection_policy.storage_endpoint
    }
  }
}

#********************* Azure SQL Failover Group ***************************************
resource "azurerm_mssql_failover_group" "fogrp" {
  count = var.secondary_sqlserver_name != null ? 1 : 0
  name      = var.failover_group_name
  server_id = azurerm_mssql_server.primary.id
  databases = azurerm_mssql_database.sqldb[*].id
  partner_server {
    id = azurerm_mssql_server.secondary[0].id
  }
  read_write_endpoint_failover_policy {
    mode = var.read_write_endpoint_failover_policy.mode
    grace_minutes = var.read_write_endpoint_failover_policy.grace_minutes
  }
  tags = var.failover_group_tags
  readonly_endpoint_failover_policy_enabled  = var.readonly_endpoint_failover_policy_enabled
}

#**************************** Elastic Pool **********************************************
resource "azurerm_mssql_elasticpool" "epool" {
  count = var.elastic_pool_name != null ? 1 : 0
  name                = var.elastic_pool_name
  resource_group_name = var.resource_group_name
  location            = var.location
  server_name         = azurerm_mssql_server.primary.name
  license_type        = var.elastic_pool_licence_type
  max_size_gb         = var.elastic_pool_max_size_gb
  sku{
    name     = var.elastic_pool_sku.name
    tier     = var.elastic_pool_sku.tier
    //family   = var.elastic_pool_sku.family
    capacity = var.elastic_pool_sku.capacity
  }
  per_database_settings{
    min_capacity = var.per_database_settings.min_capacity
    max_capacity = var.per_database_settings.max_capacity
  }
}
#*********************** Azure Monitor Onboarding ***************************************
module "sqldb_diag" {
  source                     = "../AzureMonitorOnboarding/"
  count = (var.azure_monitor != null && length(azurerm_mssql_database.sqldb) != 0) ? length(var.db_names) : 0
  resource_name              = azurerm_mssql_database.sqldb[count.index].name
  resource_id                = azurerm_mssql_database.sqldb[count.index].id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["SQLInsights", true, var.logging_retention],
      ["AutomaticTuning", true, var.logging_retention],
      ["QueryStoreRuntimeStatistics", true, var.logging_retention],
      ["QueryStoreWaitStatistics", true, var.logging_retention],
      ["Errors",true, var.logging_retention],
      ["DatabaseWaitStatistics", true, var.logging_retention],
      ["Timeouts", true, var.logging_retention],
      ["Blocks", true, var.logging_retention],
      ["Deadlocks", true, var.logging_retention],
      ["DevOpsOperationsAudit", true, var.logging_retention],
      ["SQLSecurityAuditEvents", true, var.logging_retention],
    ]
    metric = [
      ["Basic",  true, var.logging_retention],
      ["InstanceAndAppAdvanced",  true, var.logging_retention],
      ["WorkloadManagement", true, var.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}


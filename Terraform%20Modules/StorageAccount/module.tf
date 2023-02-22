resource "azurerm_storage_account" "sa" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = var.storage_account_kind
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication_type
  access_tier               = var.storage_account_access_tier
  tags                      = var.tags
  cross_tenant_replication_enabled  = var.cross_tenant_replication_enabled
  min_tls_version           = var.min_tls_version
  shared_access_key_enabled = var.shared_access_key_enabled
  enable_https_traffic_only = true
  is_hns_enabled            = var.is_hns_enabled
  nfsv3_enabled             = var.nfsv3_enabled 
  large_file_share_enabled  = var.large_file_share_enabled 
  queue_encryption_key_type = var.queue_encryption_key_type
  table_encryption_key_type = var.table_encryption_key_type
  infrastructure_encryption_enabled = var.infrastructure_encryption_enabled
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  dynamic "identity" {
    for_each = var.managed_identity_type != null ? ["true"] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }

  blob_properties {
    delete_retention_policy {
      days = var.blob_soft_delete_retention_days
    }
    container_delete_retention_policy {
      days = var.container_soft_delete_retention_days
    }
    dynamic "cors_rule" {
      for_each = var.cors_rule != null ? ["true"] : []
      content {
       allowed_headers = var.cors_rule.allowed_headers
       allowed_methods = var.cors_rule.allowed_methods
       allowed_origins = var.cors_rule.allowed_origins
       exposed_headers = var.cors_rule.exposed_headers
       max_age_in_seconds = var.cors_rule.max_age_in_seconds
      }
    }
    versioning_enabled       = var.enable_versioning
    last_access_time_enabled = var.last_access_time_enabled
    change_feed_enabled      = var.change_feed_enabled
    default_service_version  = var.default_service_version
  }
  dynamic "queue_properties" {
    for_each = var.storage_account_kind == "BlobStorage" ? [] : ["true"]
    content {
      dynamic "cors_rule" {
      for_each = var.queue_cors_rule != null ? ["true"] : []
        content {
       allowed_headers = var.queue_cors_rule.allowed_headers
       allowed_methods = var.queue_cors_rule.allowed_methods
       allowed_origins = var.queue_cors_rule.allowed_origins
       exposed_headers = var.queue_cors_rule.exposed_headers
       max_age_in_seconds = var.queue_cors_rule.max_age_in_seconds
      }
    }
      dynamic "logging" {
      for_each = var.queue_logging != null ? ["true"] : []
        content {
        delete                 = var.queue_logging.delete
        read                   = var.queue_logging.read
        version                = var.queue_logging.version
        write                  = var.queue_logging.write
        retention_policy_days  = var.queue_logging.retention_policy_days
      }
    }
      dynamic "minute_metrics" {
      for_each = var.queue_minute_metrics != null ? ["true"] : []
        content {
        enabled               = var.queue_minute_metrics.enabled
        version               = var.queue_minute_metrics.version
        include_apis          = var.queue_minute_metrics.include_apis
        retention_policy_days = var.queue_minute_metrics.retention_policy_days
      } 
    }
    dynamic "hour_metrics" {
      for_each = var.queue_hour_metrics != null ? ["true"] : []
      content {
        enabled               = var.queue_hour_metrics.enabled
        version               = var.queue_hour_metrics.version
        include_apis          = var.queue_hour_metrics.include_apis
        retention_policy_days =var.queue_hour_metrics.retention_policy_days
      }
    }
    }
  }
  dynamic "share_properties" {
    for_each = var.storage_account_kind == "FileStorage" ? ["true"] : []
    content {
      retention_policy {
        days = var.share_retention_days
      }
      dynamic "cors_rule" {
        for_each = var.share_cors_rule != null ? ["true"] : []
        content {
          allowed_headers = var.share_cors_rule.allowed_headers
          allowed_methods = var.share_cors_rule.allowed_methods
          allowed_origins = var.share_cors_rule.allowed_origins
          exposed_headers = var.share_cors_rule.exposed_headers
          max_age_in_seconds = var.share_cors_rule.max_age_in_seconds
       }
      }
      dynamic "smb" {
        for_each = var.share_smb != null ? ["true"] : []
        content {
          versions = var.share_smb.versions
          authentication_types = var.share_smb.authentication_types
          kerberos_ticket_encryption_type = var.share_smb.kerberos_ticket_encryption_type
          channel_encryption_type = var.share_smb.channel_encryption_type
        }
      }
    }
  }

  dynamic "network_rules" {
    for_each = var.network_rules != null ? ["true"] : []
    content {
      default_action             = "Deny"
      bypass                     = var.network_rules.bypass
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.virtual_network_subnet_ids
      dynamic "private_link_access" {
        for_each = var.private_link_access != null ? var.private_link_access : []
        content {
          endpoint_resource_id = private_link_access.value.endpoint_resource_id
          endpoint_tenant_id = private_link_access.value.endpoint_tenant_id
        }
      }
    }
  }

  dynamic "custom_domain" {
    for_each = var.custom_domain != null ? ["true"] : []
    content {
      name          = var.custom_domain.name
      use_subdomain = var.custom_domain.use_subdomain
    }
  }
  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? ["true"] : []
    content {
      key_vault_key_id          = var.customer_managed_key.key_vault_key_id
      user_assigned_identity_id = var.customer_managed_key.user_assigned_identity_id
    }
  }
  dynamic "routing" {
    for_each = var.routing != null ? ["true"] : []
    content {
      publish_internet_endpoints  = var.routing.publish_internet_endpoints
      publish_microsoft_endpoints = var.routing.publish_microsoft_endpoints
      choice                      = var.routing.choice
    }
  }
  dynamic "azure_files_authentication" {
    for_each = var.azure_files_authentication != null ? ["true"] :[]
    content {
      directory_type   = var.azure_files_authentication
      dynamic "active_directory" {
        for_each = var.active_directory != null && var.azure_files_authentication.directory_type == "AD" ? ["true"] : []
        content {
          storage_sid         = var.active_directory.storage_sid
          domain_name         = var.active_directory.domain_name
          domain_sid          = var.active_directory.domain_sid
          domain_guid         = var.active_directory.domain_guid
          forest_name         = var.active_directory.forest_name
          netbios_domain_name = var.active_directory.netbios_domain_name

        }
      }
    }
  }
#------------------------Static website hosting in Azure Blob Storage -------------------------------
# Please refer to the links in the documentation for more information on this.

  dynamic "static_website" {
    for_each = var.static_website != null ? ["true"] : []
    content {
      index_document     = var.static_website.index_document
      error_404_document = var.static_website.error_404_document
    }
  }
}
########## OPTIONAL ##########
resource "azurerm_advanced_threat_protection" "atp" {
  count = var.enable_advanced_threat_protection ? 1 :0
  target_resource_id = azurerm_storage_account.sa.id
  enabled            = var.enable_advanced_threat_protection
}

# Storage Containers
resource "azurerm_storage_container" "container" {
  count                 = length(var.containers_list)
  name                  = var.containers_list[count.index].name
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = var.containers_list[count.index].access_type
}
# Fileshares
resource "azurerm_storage_share" "fileshare" {
  count                = length(var.file_shares)
  name                 = var.file_shares[count.index].name
  storage_account_name = azurerm_storage_account.sa.name
  quota                = var.file_shares[count.index].quota
}
# Storage Tables
resource "azurerm_storage_table" "tables" {
  count                = length(var.tables)
  name                 = var.tables[count.index]
  storage_account_name = azurerm_storage_account.sa.name
}
# Storage Queues
resource "azurerm_storage_queue" "queues" {
  count                = length(var.queues)
  name                 = var.queues[count.index]
  storage_account_name = azurerm_storage_account.sa.name
}

#### Azure monitor onboarding for storage account ####
#For each Storage account logging 

module "storage_diag" {
  source                     = "../AzureMonitorOnboarding/"
  count = var.azure_monitor != null ? 1 : 0
  resource_name              = azurerm_storage_account.sa.name
  resource_id                = azurerm_storage_account.sa.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
    ]
    metric = [
      ["Transaction", true, var.logging_retention],
      ["Capacity", true, var.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}


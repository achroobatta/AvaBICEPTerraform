#random number generator to generate unique names for sa and eh namespace
resource "random_integer" "rng" {
  min = 0
  max = 999
}

#create log analytics workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  sku                 = var.log_analytics_workspace_sku
  retention_in_days   = var.log_analytics_workspace_retention
  daily_quota_gb = var.log_analytics_workspace_daily_quota
  internet_ingestion_enabled = var.log_analytics_workspace_ingestion
  internet_query_enabled = var.log_analytics_workspace_query
  #Only enter value if var.log_analytics_workspace_sku == "CapacityReservation"
  reservation_capacity_in_gb_per_day = var.log_analytics_workspace_sku == "CapacityReservation" ? var.log_analytics_workspace_reservation : null
}


#create optional eventhub namespace
resource "azurerm_eventhub_namespace" "ehnamespace" {
  count = var.eventhub_required ? 1 : 0
  name                = "${var.name}${local.rng}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.eventhub_sku
  #Only enter value if var.eventhub_sku == "Basic" 
  capacity            = var.eventhub_sku == "Basic" ? var.eventhub_capacity : null
  zone_redundant = var.eventhub_zone_redundant
  auto_inflate_enabled = var.eventhub_auto_inflate
  # only enter value if var.eventhub_auto_inflate is true
  maximum_throughput_units = var.eventhub_auto_inflate ? var.eventhub_throughput : null
  dedicated_cluster_id = var.eventhub_dedicated_cluster
  tags = var.tags
  #dynamic block to configure network rules if not equal null
  dynamic "network_rulesets" {
    for_each = var.eventhub_network_rules != null ? ["true"] : []
    content {
      default_action = "Deny"
      trusted_service_access_enabled = var.eventhub_network_rules.trusted_service_access_enabled
      dynamic "ip_rule" {
        for_each = var.eventhub_network_rules.ip_rules != null ? var.eventhub_network_rules.ip_rules : []
        iterator = iprule
        content {
          ip_mask = iprule.value
        }
      }

      dynamic "virtual_network_rule" {
        for_each = var.eventhub_network_rules.subnet_ids != null ? var.eventhub_network_rules.subnet_ids : []
        iterator = subnet
        content {
          subnet_id = subnet.value
        }
      }
    }
  }
}

#create optional eventhub
resource "azurerm_eventhub" "eh" {
  count = var.eventhub_required ? 1 : 0
  name                = var.name
  namespace_name      = azurerm_eventhub_namespace.ehnamespace[0].name
  resource_group_name = var.resource_group_name
  partition_count     = var.eventhub_parition_count
  message_retention   = var.eventhub_message_retention
  status = var.eventhub_status
}



#create optional storage account for logs
resource "azurerm_storage_account" "sa" {
  count = var.storage_account_required ? 1 : 0
  name                      = "${var.name}${local.rng}"
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = var.storage_account_tier
  account_replication_type  = var.storage_account_replication_type
  account_kind              = var.storage_account_kind
  access_tier               = var.storage_account_access_tier
  tags                      = var.tags
  #enforces https
  enable_https_traffic_only = true
}
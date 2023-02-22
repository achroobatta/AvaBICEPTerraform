resource "azurerm_bastion_host" "bastion" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  copy_paste_enabled = var.copy_paste_enabled
  file_copy_enabled = var.file_copy_enabled
  ip_connect_enabled = var.ip_connect_enabled
  shareable_link_enabled = var.shareable_link_enabled
  tunneling_enabled = var.tunneling_enabled
  scale_units = var.scale_units
  sku = var.sku

  #dynamic code block for ip_configuration
  dynamic "ip_configuration" {
    for_each = var.ip_configuration != null ? [true] : []
    content {
      name                 = var.ip_configuration.name
      subnet_id            = var.ip_configuration.subnet_id
      public_ip_address_id = var.ip_configuration.public_ip_address_id
    }
  }
}

#bastion logging
module "bastion_diag" {
  count = var.azure_monitor != null ? 1 : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_bastion_host.bastion.name
  resource_id                = azurerm_bastion_host.bastion.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["BastionAuditLogs", true, var.logging_retention],
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
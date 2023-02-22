resource "azurerm_firewall" "afw" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id = var.firewall_policy_id
  dns_servers = var.dns_servers
  private_ip_ranges = var.private_ip_ranges
  threat_intel_mode = var.threat_intel_mode
  zones = var.zones

  #dynamic code block for ip_configuration
  dynamic "ip_configuration" {
    for_each = var.ip_configurations != null ? var.ip_configurations : []
    content {
      name                 = ip_configuration.value.name
      subnet_id            = ip_configuration.value.subnet_id
      public_ip_address_id = ip_configuration.value.public_ip_address_id
    }
  }
  #dynamic code block for management_ip_configuration
  dynamic "management_ip_configuration" {
    for_each = var.management_ip_configuration != null ? [true] : []
    content {
      name                 = var.management_ip_configuration.name
      subnet_id            = var.management_ip_configuration.subnet_id
      public_ip_address_id = var.management_ip_configuration.public_ip_address_id
    }
  }
  #dynamic code block for virtual_hub
  dynamic "virtual_hub" {
    for_each = var.virtual_hub != null ? [true] : []
    content {
      virtual_hub_id = var.virtual_hub.virtual_hub_id
      public_ip_count = var.virtual_hub.public_ip_count
    }
  }
}

#azfw logging
module "azfw_diag" {
  count = var.azure_monitor != null ? 1 : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_firewall.afw.name
  resource_id                = azurerm_firewall.afw.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["AzureFirewallApplicationRule", true, var.logging_retention],
      ["AzureFirewallNetworkRule", true, var.logging_retention],
      ["AzureFirewallDnsProxy", true, var.logging_retention],
      ["AZFWNetworkRule", true, var.logging_retention],
      ["AZFWThreatIntel", true, var.logging_retention],
      ["AZFWIdpsSignature", true, var.logging_retention],
      ["AZFWDnsQuery", true, var.logging_retention],
      ["AZFWFqdnResolveFailure", true, var.logging_retention],
      ["AZFWNetworkRuleAggregation", true, var.logging_retention],
      ["AZFWApplicationRuleAggregation", true, var.logging_retention],
      ["AZFWNatRuleAggregation", true, var.logging_retention],
      ["AZFWNatRule", true, var.logging_retention],
       ["AZFWApplicationRule", true, var.logging_retention],
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

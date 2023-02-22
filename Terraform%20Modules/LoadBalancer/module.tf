#provision lb
resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags

  edge_zone = var.edge_zone
  sku = var.sku
  sku_tier = var.sku_tier

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
    name                 = "${var.name}-${frontend_ip_configuration.value.name}"
    private_ip_address = frontend_ip_configuration.value.private_ip_address
    public_ip_address_id = frontend_ip_configuration.value.public_ip_address_id
    public_ip_prefix_id = frontend_ip_configuration.value.public_ip_prefix_id
    zones = frontend_ip_configuration.value.zones
    subnet_id = frontend_ip_configuration.value.subnet_id
    gateway_load_balancer_frontend_ip_configuration_id = frontend_ip_configuration.value.gateway_load_balancer_frontend_ip_configuration_id
    private_ip_address_allocation = frontend_ip_configuration.value.private_ip_address_allocation
    private_ip_address_version = frontend_ip_configuration.value.private_ip_address_version
      }
    }

}

#optional nat rule configuration
resource "azurerm_lb_nat_rule" "natrules" {
  count = var.nat_configurations != null ? length(var.nat_configurations):0
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.nat_configurations[count.index].name
  protocol                       = var.nat_configurations[count.index].protocol
  frontend_port                  = var.nat_configurations[count.index].frontend_port
  backend_port                   = var.nat_configurations[count.index].backend_port
  frontend_ip_configuration_name = var.nat_configurations[count.index].frontend_ip_configuration_name
}

resource "azurerm_network_interface_nat_rule_association" "natruleassociations" {
  count = var.nat_configurations != null ? length(var.nat_configurations):0
  network_interface_id  = var.nat_configurations[count.index].network_interface_id
  ip_configuration_name = var.nat_configurations[count.index].ip_configuration_name
  nat_rule_id           = azurerm_lb_nat_rule.natrules[count.index].id
}

#optional configuration of backend pools, probes and lb rules
resource "azurerm_lb_backend_address_pool" "backendpool" {
  count = var.backendpool_configuration != null ? 1:0
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.backendpool_configuration.name
}

resource "azurerm_network_interface_backend_address_pool_association" "backendpoolassociation" {
  count = var.backendpool_configuration != null ? length(var.backendpool_configuration.network_interface_ids):0
  network_interface_id  = var.backendpool_configuration.network_interface_ids[count.index]
  ip_configuration_name = var.backendpool_configuration.ip_configuration_names[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendpool[0].id
}

resource "azurerm_lb_probe" "lbprobe" {
  count = var.backendpool_configuration != null ? 1:0
  loadbalancer_id = azurerm_lb.lb.id
  name            = var.backendpool_configuration.name
  port            = var.backendpool_configuration.backend_port
}

resource "azurerm_lb_rule" "lbrule" {
  count = var.backendpool_configuration != null ? 1:0
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = var.backendpool_configuration.name
  protocol                       = var.backendpool_configuration.protocol
  frontend_port                  = var.backendpool_configuration.frontend_port
  backend_port                   = var.backendpool_configuration.backend_port
  frontend_ip_configuration_name = var.backendpool_configuration.frontend_ip_configuration_name
  backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.backendpool[0].id}"]
  probe_id = azurerm_lb_probe.lbprobe[0].id
}

#lb logging
module "azlb_diag" {
  count = var.azure_monitor != null ? 1 : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_lb.lb.name
  resource_id                = azurerm_lb.lb.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["LoadBalancerAlertEvent", true, var.logging_retention],
      ["LoadBalancerProbeHealthStatus", true, var.logging_retention],
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
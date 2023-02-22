#create expressroute gw
resource "azurerm_express_route_gateway" "ergw" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_hub_id      = var.virtual_hub_id
  scale_units         = var.scale_units

  tags = var.tags
}

resource "azurerm_express_route_circuit" "ercircuits" {
  count = var.circuits != null ? length(var.circuits):0
  name                  = var.circuits[count.index].name
  resource_group_name   = var.resource_group_name
  location              = var.location
  service_provider_name = var.circuits[count.index].service_provider_name
  peering_location      = var.circuits[count.index].peering_location
  bandwidth_in_mbps     = var.circuits[count.index].bandwidth_in_mbps

  sku {
    tier   = var.circuits[count.index].sku_tier
    family = var.circuits[count.index].sku_family
  }

  tags = var.tags
}

#logging for each circuit
module "ercircuit_diag" {
  count = var.azure_monitor != null ? length(var.circuits) : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_express_route_circuit.ercircuits[count.index].name
  resource_id                = azurerm_express_route_circuit.ercircuits[count.index].id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["PeeringRouteLog", true, var.logging_retention],
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
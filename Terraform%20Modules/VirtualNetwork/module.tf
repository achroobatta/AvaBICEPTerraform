#create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  tags                = var.tags
  dns_servers         = var.dns_servers
  bgp_community = var.bgp_community
  edge_zone = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  #create dynamic protection plan configuration if variable ddos_protection_plan_id not equal null
  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id != null ? [""] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
}

#create subnets as per definition
resource "azurerm_subnet" "subnets" {
  count = length(var.subnet_definition)
  name                 = var.subnet_definition[count.index].name
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  address_prefixes       = var.subnet_definition[count.index].prefix
  service_endpoints = var.subnet_definition[count.index].service_endpoints
  private_link_service_network_policies_enabled = var.subnet_definition[count.index].enforce_private_link_service_network_policies
  private_endpoint_network_policies_enabled = var.subnet_definition[count.index].enforce_private_link_endpoint_network_policies
  
  #dynamically create delegations if it is not equal to null
  dynamic "delegation" {
    for_each = var.subnet_definition[count.index].delegations != null ? var.subnet_definition[count.index].delegations : []
    content {
      name = delegation.value
      service_delegation {
        name    = delegation.value
        #extract action mapping from local.tf based on provided delegations
        actions = formatlist("Microsoft.Network/%s", local.service_delegation_actions[delegation.value])
      }
    }
  }
}

#create nsg per subnet previously created
resource "azurerm_network_security_group" "nsgs" {
  count = length(var.subnet_definition)
  name                = "${var.subnet_definition[count.index].name}_NSG"
  location            = var.location
  resource_group_name = var.resource_group_name
}

#attach the nsg to respective subnet
resource "azurerm_subnet_network_security_group_association" "attachnsg" {
  count = length(var.subnet_definition)
  subnet_id                 = azurerm_subnet.subnets[count.index].id
  network_security_group_id = azurerm_network_security_group.nsgs[count.index].id
}

#default rules for every nsg created##########################################
resource "azurerm_network_security_rule" "DenyAllInBoundDefaultRule" {
  count = length(var.subnet_definition)
  name                        = "DenyAllInBoundDefaultRule"
  priority                    = 4000
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgs[count.index].name
}

resource "azurerm_network_security_rule" "AllowMonitorDefaultRule" {
  count = length(var.subnet_definition)
  name                        = "AllowMonitorDefaultRule"
  priority                    = 3000
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_ranges      = ["80","443"]
  source_address_prefix       = "*"
  destination_address_prefix  = "AzureMonitor"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgs[count.index].name
}

resource "azurerm_network_security_rule" "DenyAllOutBoundDefaultRule" {
  count = length(var.subnet_definition)
  name                        = "DenyAllOutBoundDefaultRule"
  priority                    = 4000
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsgs[count.index].name
}
###################################################################################

#network flow log for each nsg
resource "azurerm_network_watcher_flow_log" "networkwatchers" {
  count = var.network_watcher_name != null ? length(var.subnet_definition) : 0
  name                 = "${var.subnet_definition[count.index].name}_networkwatcherlog"
  network_watcher_name = var.network_watcher_name
  resource_group_name  = var.network_watcher_resource_group_name

  network_security_group_id = azurerm_network_security_group.nsgs[count.index].id
  storage_account_id        = var.azure_monitor.sa_out.id
  enabled                   = true

  retention_policy {
    enabled = true
    days    = var.network_watcher_retention
  }

  traffic_analytics {
    enabled               = true
    workspace_id          = var.azure_monitor.law_out.workspace_id
    workspace_region      = var.azure_monitor.law_out.location
    workspace_resource_id = var.azure_monitor.law_out.id
    interval_in_minutes   = 10
  }
}

#vnet logging
module "vnet_diag" {
  count = var.azure_monitor != null ? 1 : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_virtual_network.vnet.name
  resource_id                = azurerm_virtual_network.vnet.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["VMProtectionAlerts", true, var.logging_retention],
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

#nsg logging for each nsg
module "nsg_diag" {
  count = (var.azure_monitor != null && length(azurerm_network_security_group.nsgs) != 0) ? length(var.subnet_definition) : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = azurerm_network_security_group.nsgs[count.index].name
  resource_id                = azurerm_network_security_group.nsgs[count.index].id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", Retention period] 
      ["NetworkSecurityGroupEvent", true, var.logging_retention],
      ["NetworkSecurityGroupRuleCounter", true, var.logging_retention],
    ]
    metric = [
      #["AllMetrics", true, var.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}

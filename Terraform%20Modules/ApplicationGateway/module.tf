resource "azurerm_public_ip" "frontend" {
  name                = var.public_ip_name
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = var.allocation_method
  sku = var.public_ip_sku
}
#************************* Application Gateway ***************************************

resource "azurerm_application_gateway" "gateway" {
  name                              = var.application_gateway_name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  enable_http2                      = var.enable_http2
  firewall_policy_id                = var.firewall_policy_id != null ? var.firewall_policy_id : null
  fips_enabled                      = var.fips_enabled
  force_firewall_policy_association = var.force_firewall_policy_association
  tags                              = var.tags
  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = var.autoscale_configuration == null ? var.sku.capacity : null
  }
  dynamic "autoscale_configuration" {
    for_each = var.autoscale_configuration != null ? [var.autoscale_configuration] : []
    content {
      min_capacity = lookup(autoscale_configuration.value, "min_capacity")
      max_capacity = lookup(autoscale_configuration.value, "max_capacity")
    }
  }
  frontend_port {
    name = local.http_frontend_port_name
    port = var.frontend_http_port
  }
  frontend_port {
    name = local.https_frontend_port_name
    port = var.frontend_https_port
  }
  frontend_ip_configuration {
    name                 = local.frontend_ip_configuration_name
    public_ip_address_id = azurerm_public_ip.frontend.id
  }
  gateway_ip_configuration {
    name      = "${var.application_gateway_name}-gwic"
    subnet_id = var.subnet_id
  }
  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      ip_addresses = backend_address_pool.value.ip_addresses
      fqdns        = backend_address_pool.value.fqdns
    }
  }
  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.enable_cookie_based_affinity ? "Enabled" : "Disabled"
      path                                = backend_http_settings.value.path
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = backend_http_settings.value.request_timeout
      probe_name                          = backend_http_settings.value.probe_name
      host_name                           = backend_http_settings.value.pick_host_name_from_backend_address == false ? backend_http_settings.value.host_name : null
      pick_host_name_from_backend_address = backend_http_settings.value.pick_host_name_from_backend_address
      dynamic "authentication_certificate" {
        for_each = lookup(backend_http_settings.value, "authentication_certificate", [])
        content {
          name = authentication_certificate.value.name

        }
      }
      trusted_root_certificate_names = var.trusted_root_certificate_names
      dynamic "connection_draining" {
        for_each = var.connection_draining != null ? ["true"] : []
        content {
            enabled = var.connection_draining.enabled
            drain_timeout_sec = var.connection_draining.drain_timeout_sec
        }
      }
    }
  }
  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = local.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.ssl_certificate_name != null ? local.https_frontend_port_name : local.http_frontend_port_name
      protocol                       = http_listener.value.ssl_certificate_name != null ? "Https" : "Http"
      ssl_certificate_name           = http_listener.value.ssl_certificate_name
      # The host_names and host_name are mutually exclusive and cannot both be set.
      host_name  = lookup(http_listener.value, "host_name", null)
      host_names = http_listener.value.host_name == null ? http_listener.value.host_names : null
      require_sni = (http_listener.value.ssl_certificate_name != null ? http_listener.value.require_sni : null)
      dynamic "custom_error_configuration" {
        for_each = var.custom_error_configuration != null ? ["true"] : []
        content {
            status_code = var.custom_error_configuration.status_code
            custom_error_page_url= var.custom_error_configuration.custom_error_page_url
        }
      }
    }
  }
  dynamic "identity" {
    for_each = var.identity_ids != null ? [1] : []
    content {
      type         = "UserAssigned"
      identity_ids = var.identity_ids
    }
  }
   # Basic rules
  dynamic "request_routing_rule" {
    for_each = var.basic_request_routing_rules
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = "Basic"
      http_listener_name          = request_routing_rule.value.http_listener_name
      backend_address_pool_name   = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name  = request_routing_rule.value.backend_http_settings_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
      priority                    = request_routing_rule.value.priority
    }
  }
   # Redirect Rules
  dynamic "request_routing_rule" {
    for_each = var.redirect_request_routing_rules
    content {
      name                        = request_routing_rule.value.name
      rule_type                   = "Basic"
      http_listener_name          = request_routing_rule.value.http_listener_name
      redirect_configuration_name = request_routing_rule.value.redirect_configuration_name
      rewrite_rule_set_name       = request_routing_rule.value.rewrite_rule_set_name
      priority                    = request_routing_rule.value.priority
    }
  }

  # Path based request routing
  dynamic "request_routing_rule" {
    for_each = var.path_based_request_routing_rules
    content {
      name               = request_routing_rule.value.name
      rule_type          = "PathBasedRouting"
      http_listener_name = request_routing_rule.value.http_listener_name
      url_path_map_name  = request_routing_rule.value.url_path_map_name
    }
  }
  dynamic "probe" {
    for_each = var.probes != null ? var.probes : []
    content {
      name                = probe.value.name
      path                = probe.value.path
      protocol            = probe.value.protocol
      interval            = probe.value.interval
      timeout             = probe.value.timeout
      unhealthy_threshold = probe.value.unhealthy_threshold
      port                = probe.value.port
      minimum_servers     = probe.value.minimum_servers
      host                = probe.value.host
      match {
        body        = probe.value.match_body
        status_code = probe.value.match_status_codes
      }

      pick_host_name_from_backend_http_settings = probe.value.pick_host_name_from_backend_http_settings
    }
  }
  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name                = ssl_certificate.value.name
      data                = ssl_certificate.value.pfx_data
      password            = ssl_certificate.value.pfx_password
      key_vault_secret_id = ssl_certificate.value.key_vault_secret_id
    }
  }
  dynamic "ssl_policy"{
    for_each = var.ssl_policy != null ? [1] : []
    content{
      policy_type    = var.ssl_policy.policy_type
      policy_name    = var.ssl_policy.policy_name
      disabled_protocols = var.ssl_policy.disabled_protocols
      cipher_suites = var.ssl_policy.cipher_suites
      min_protocol_version = var.ssl_policy.min_protocol_version
    }
  }  

   # Rewrite rule set

  dynamic "rewrite_rule_set" {
    for_each = var.rewrite_rule_sets
    content {
      name = rewrite_rule_set.value.name

      dynamic "rewrite_rule" {
        for_each = rewrite_rule_set.value.rewrite_rules
        iterator = rule
        content {
          name          = rule.value.name
          rule_sequence = rule.value.rule_sequence

          dynamic "condition" {
            for_each = rule.value.conditions
            iterator = cond
            content {
              variable    = cond.value.variable
              pattern     = cond.value.pattern
              ignore_case = cond.value.ignore_case
              negate      = cond.value.negate
            }
          }

          dynamic "response_header_configuration" {
            for_each = rule.value.response_header_configurations
            iterator = header
            content {
              header_name  = header.value.header_name
              header_value = header.value.header_value
            }
          }

          dynamic "request_header_configuration" {
            for_each = rule.value.request_header_configurations
            iterator = header
            content {
              header_name  = header.value.header_name
              header_value = header.value.header_value
            }
          }

          dynamic "url" {
            for_each = rule.value.url != null ? ["enabled"] : []
            content {
              path         = rule.value.url.path
              query_string = rule.value.url.query_string
              components   = rule.value.url.components
              reroute      = rule.value.url.reroute
            }
          }
        }
      }
    }
  }

}

#******************************* Azure Monitor Onboarding **************************
module "gateway_diag" {
  source                     = "../AzureMonitorOnboarding/"
  count = var.azure_monitor != null ? 1 : 0
  resource_name              = azurerm_application_gateway.gateway.name
  resource_id                = azurerm_application_gateway.gateway.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["ApplicationGatewayAccessLog", true, var.logging_retention],
      ["ApplicationGatewayPerformanceLog", true, var.logging_retention],
      ["ApplicationGatewayFirewallLog", true, var.logging_retention],
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


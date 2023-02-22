#create s2s vpn gw
resource "azurerm_vpn_gateway" "s2svpn" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  virtual_hub_id      = var.virtual_hub_id
  tags = var.tags
  bgp_route_translation_for_nat_enabled = var.bgp_route_translation_for_nat_enabled
  routing_preference = var.routing_preference
  scale_unit = var.scale_unit
  # dynamic block of bgp_setting
  dynamic "bgp_settings"{
    for_each = var.bgp_settings != null ? [true] : []
    content {
      asn = var.bgp_settings.asn
      peer_weight = var.bgp_settings.peer_weight
      # nested block for instance_0_bgp_peering_address based on variable instance_0_bgp_peering_address_custom_ips
      dynamic "instance_0_bgp_peering_address"{
        for_each = var.bgp_settings.instance_0_bgp_peering_address_custom_ips != null ? [true] : []
        content {
          custom_ips = var.bgp_settings.instance_0_bgp_peering_address_custom_ips
        }
      }
      # nested block for instance_1_bgp_peering_address based on variable instance_0_bgp_peering_address_custom_ips
      dynamic "instance_1_bgp_peering_address"{
        for_each = var.bgp_settings.instance_1_bgp_peering_address_custom_ips != null ? [true] : []
        content {
          custom_ips = var.bgp_settings.instance_1_bgp_peering_address_custom_ips
        }
      }
    }
  }
}

#optionally create vpn site
resource "azurerm_vpn_site" "vpnsite" {
  #create only if var.links is not empty
  count = var.links != null ? 1: 0
  name                = "${var.name}site"
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = var.virtual_wan_id
  tags = var.tags
  address_cidrs       = var.address_cidrs
  device_model = var.device_model
  device_vendor = var.device_vendor
  #o365_policy dynamic block
  dynamic "o365_policy"{
    for_each = var.o365_policy != null ? [true]:[]
    content{
      traffic_category {
        allow_endpoint_enabled= var.o365_policy.allow_endpoint_enabled
        default_endpoint_enabled= var.o365_policy.default_endpoint_enabled
        optimize_endpoint_enabled= var.o365_policy.optimize_endpoint_enabled
      }
    }
  }
  #link dynamic block
  dynamic "link"{
    for_each = var.links
    content{
      name = link.value.name
      fqdn = link.value.fqdn
      ip_address = link.value.ip_address
      provider_name = link.value.provider_name
      speed_in_mbps = link.value.speed_in_mbps
      #dynamic block for bgp based on variable bgp_asn AND bgp_peering_address
      dynamic "bgp" {
        for_each = link.value.bgp_asn !=null && link.value.bgp_peering_address != null ? [true]:[]
        content{
          asn = link.value.bgp_asn
          peering_address = link.value.bgp_peering_address
        }
      }
    }
  }
}

#optionally create vpn connection
resource "azurerm_vpn_gateway_connection" "vpn_connection" {
  #create only if var.links is not empty
  count = var.links != null ? 1: 0
  name               = "${var.name}siteconnection"
  vpn_gateway_id     = azurerm_vpn_gateway.s2svpn.id
  remote_vpn_site_id = azurerm_vpn_site.vpnsite[0].id
  #dynamic block for traffic_selector_policy
  dynamic "traffic_selector_policy" {
    #create only when var.traffic_selector_policy is not empty
    for_each = var.traffic_selector_policies!=null?var.traffic_selector_policies:[]
    content {
      local_address_ranges = traffic_selector_policy.value.local_address_ranges
      remote_address_ranges = traffic_selector_policy.value.remote_address_ranges
    }
  }
  #dynamic block for routing
  dynamic "routing"{
    for_each = var.associated_route_table != null ? [true]: []
    content{
      associated_route_table = var.associated_route_table
      #nested dynamic block based on var.propagated_route_table existence
      dynamic "propagated_route_table"{
        for_each = var.propagated_route_table != null ? [true]: []
        content{
          route_table_ids = var.propagated_route_table.route_table_ids
          labels = var.propagated_route_table.labels
        }
      }
    }
  }
  #dynamic block for vpn link based on numbers of var.links
  dynamic "vpn_link"{
    for_each = var.links
    content{
      name = vpn_link.value.name
      #uses link names to match and create an index to reference to vpn site link
      vpn_site_link_id = azurerm_vpn_site.vpnsite[0].link[index(var.links[*].name, vpn_link.value.name)].id
      bandwidth_mbps = vpn_link.value.speed_in_mbps
      bgp_enabled = vpn_link.value.bgp_enabled
      connection_mode = vpn_link.value.connection_mode
      protocol = vpn_link.value.protocol
      egress_nat_rule_ids = vpn_link.value.egress_nat_rule_ids
      ingress_nat_rule_ids = vpn_link.value.ingress_nat_rule_ids
      ratelimit_enabled = vpn_link.value.ratelimit_enabled
      route_weight = vpn_link.value.route_weight
      shared_key = vpn_link.value.shared_key
      local_azure_ip_address_enabled = vpn_link.value.local_azure_ip_address_enabled
      policy_based_traffic_selector_enabled = vpn_link.value.policy_based_traffic_selector_enabled
      #nested block for custom_bgp_address
      dynamic "custom_bgp_address"{
        #created only if custom_bgp_ip_address and custom_bgp_ip_configuration_id is populated
        for_each = vpn_link.value.custom_bgp_ip_address !=null && vpn_link.value.custom_bgp_ip_configuration_id != null ? [true]:[]
        content{
          ip_address= vpn_link.value.custom_bgp_ip_address
          ip_configuration_id = vpn_link.value.custom_bgp_ip_configuration_id
        }
      }
      #nested block for ipsec_policy, all links uses the same ipsec_policy. Create vpn_link and vpn_gw_connection outside of module if this is not desired
      dynamic "ipsec_policy"{
        for_each = var.ipsec_policies != null ? var.ipsec_policies: []
        content{
          dh_group = ipsec_policy.value.dh_group
          ike_encryption_algorithm = ipsec_policy.value.ike_encryption_algorithm
          ike_integrity_algorithm = ipsec_policy.value.ike_integrity_algorithm
          encryption_algorithm = ipsec_policy.value.encryption_algorithm
          integrity_algorithm = ipsec_policy.value.integrity_algorithm
          pfs_group = ipsec_policy.value.pfs_group
          sa_lifetime_sec = ipsec_policy.value.sa_lifetime_sec
          sa_data_size_kb = ipsec_policy.value.sa_data_size_kb
        }
      }
    }
  }
}
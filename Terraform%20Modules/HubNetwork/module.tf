#create WAN
resource "azurerm_virtual_wan" "wan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  type = var.wan_type
  disable_vpn_encryption = var.disable_vpn_encryption
  allow_branch_to_branch_traffic = var.allow_branch_to_branch_traffic
  office365_local_breakout_category = var.office365_local_breakout_category
}

#create hub
resource "azurerm_virtual_hub" "hub" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  virtual_wan_id      = azurerm_virtual_wan.wan.id
  address_prefix      = var.hub_address_prefix
  sku = var.hub_sku
  #dynamic block for route
  dynamic "route"{
    for_each = var.routes != null ? var.routes : []
    content {
      address_prefixes = route.value.address_prefixes
      next_hop_ip_address = route.value.next_hop_ip_address
    }
  }
}
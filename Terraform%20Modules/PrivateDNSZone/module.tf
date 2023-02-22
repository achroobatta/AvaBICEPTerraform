#provision private dns zone
resource "azurerm_private_dns_zone" "privatednszone" {
  name                = var.name
  resource_group_name = var.resource_group_name
  tags= var.tags
  #dynamic block for soa_record
  dynamic "soa_record"{
    for_each = var.soa_record != null ? [true]:[]
    content {
      email = var.soa_record.email
      expire_time = var.soa_record.expire_time
      minimum_ttl = var.soa_record.minimum_ttl
      refresh_time = var.soa_record.refresh_time
      retry_time = var.soa_record.retry_time
      ttl = var.soa_record.ttl
      tags = var.tags
    }
  }
}

#provision vnet link
resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink" {
  count = var.virtual_network_ids != null ? length(var.virtual_network_ids) : 0
  name                  = "${var.name}${count.index}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.privatednszone.name
  virtual_network_id    = var.virtual_network_ids[count.index].id
  registration_enabled = var.virtual_network_ids[count.index].registration_enabled
  tags = var.tags
}
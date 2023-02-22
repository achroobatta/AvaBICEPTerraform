
output "p2sgw_out" {
  value = azurerm_point_to_site_vpn_gateway.p2sgw
}

output "vpnconfig_out" {
  value = azurerm_vpn_server_configuration.vpnserverconfig
}

output "s2sgw_out" {
  value = azurerm_vpn_gateway.s2svpn
}

output "vpnsite_out" {
  value = azurerm_vpn_site.vpnsite
}

output "vpnconnection_out" {
  value = azurerm_vpn_gateway_connection.vpn_connection
}
output "pip_out" {
  value = azurerm_public_ip.frontend
}
output "gateway_out" {
  value = azurerm_application_gateway.gateway
}
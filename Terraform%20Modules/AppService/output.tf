output "app_service_plan" {
  value = azurerm_service_plan.app_plan
}
output "app_service_environment" {
  value = azurerm_app_service_environment.appse_environment
}
output "linux_app" {
  value = azurerm_linux_web_app.linux
}
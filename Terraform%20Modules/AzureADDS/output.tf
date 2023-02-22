
output "aadds_out" {
  value = azurerm_active_directory_domain_service.aadds
}

output "adminuser_out" {
  value = azuread_user.admin
}

output "dcadmins_out" {
  value = azuread_group.dc_admins
}

output "aaddsspn_out" {
  value = azuread_service_principal.aaddsspn
}
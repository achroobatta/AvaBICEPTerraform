output "akv_out" {
  value = azurerm_key_vault.akv
}

output "akvap_out" {
  value = azurerm_key_vault_access_policy.tfacctpolicy
}
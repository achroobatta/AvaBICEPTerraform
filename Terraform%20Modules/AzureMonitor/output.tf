output "law_out" {
  value = azurerm_log_analytics_workspace.law
}

output "sa_out" {
  value = azurerm_storage_account.sa
}

output "ehnamespace_out" {
  value = azurerm_eventhub_namespace.ehnamespace
}

output "eh_out" {
  value = azurerm_eventhub.eh
}
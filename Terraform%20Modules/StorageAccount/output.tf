output "sa_out" {
  value       = azurerm_storage_account.sa
}

output "containers_out" {
  description = "Map of containers."
  value       = { for c in azurerm_storage_container.container : c.name => c.id }
}

output "file_shares_out" {
  description = "Map of Storage SMB file shares."
  value       = { for f in azurerm_storage_share.fileshare : f.name => f.id }
}

output "tables_out" {
  description = "Map of Storage tables."
  value       = { for t in azurerm_storage_table.tables : t.name => t.id }
}

output "queues_out" {
  description = "Map of Storage queues."
  value       = { for q in azurerm_storage_queue.queues : q.name => q.id }
}

output "rt_out" {
  value = azurerm_route_table.rtable
}
output "rt_association" {
  value = azurerm_subnet_route_table_association.rt_association
}
output "primary_instance_out" {
  value = azurerm_mssql_managed_instance.primary
}
output "secondary_instance_out" {
  value = azurerm_mssql_managed_instance.secondary
}
output "fail_over_group" {
  value = azurerm_mssql_managed_instance_failover_group.failover
}
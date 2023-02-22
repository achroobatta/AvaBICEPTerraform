output "primary_sql_server" {
  value = azurerm_mssql_server.primary
}
output "secondary_sql_server" {
  value = azurerm_mssql_server.secondary
}
output "sql_db" {
  value = azurerm_mssql_database.sqldb
}

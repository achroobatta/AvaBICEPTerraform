
output "vnet_out" {
  value = azurerm_virtual_network.vnet
}

output "subnets_out" {
  value = azurerm_subnet.subnets
}

output "nsgs_out" {
  value = azurerm_network_security_group.nsgs
}
/*
output "subnetsid_out" {
  value = {
    for azurerm_subnet in azurerm_subnet.subnets :
    #map of subnet name = subnet id
    azurerm_subnet.name => azurerm_subnet.id
  }
}

output "nsgsid_out" {
  value = {
    for azurerm_network_security_group in azurerm_network_security_group.nsgs :
    #map of nsg name = nsg id
    azurerm_network_security_group.name => azurerm_network_security_group.id
  }
}
*/
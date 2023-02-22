output "vm_out" {
  value = azurerm_windows_virtual_machine.vm
}


output "vm_nics_out" {
  value = azurerm_network_interface.vmnics
}

output "vm_disks_out" {
  value = azurerm_managed_disk.disks
}
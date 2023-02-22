terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.13.0"
    }
  }
  backend "azurerm" {
    #resource_group_name  = "lzdemo-tfstate-rg"
    storage_account_name = "fy22assettfsa"
    container_name       = "livenonprod"
    key                  = "livenonprod.tfstate"
  }
}

provider "azurerm" {
    features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "avatest" {
  name     = "avatest"
  location = "Australia East"
}

module "azure_monitor" {
  source = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//AzureMonitor"
  name = "avatest"
  location = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  storage_account_required = true
  eventhub_required = true
  /*
  eventhub_network_rules = {
    ip_rules =  ["10.0.0.0/16"] 
    subnet_ids =  null 
    trusted_service_access_enabled = true
  }
  */
}

/*
resource "azurerm_network_ddos_protection_plan" "ddos" {
  name                = "example-protection-plan"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
}
*/

module "akv" {
  source  = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//KeyVault"
  name  = "avatestakv1"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  azure_monitor = module.azure_monitor
  sku_name = "standard"
  /*
  contacts = [{
    email = "v@v.com"
    name = null
    phone = "9999"
  }]
  network_acls = {
    bypass = "AzureServices"
    default_action = "Deny"
    ip_rules= ["11.0.0.0/8"]
    virtual_network_subnet_ids=[]
  }
  */
}

/*
#additional akv access policies
resource "azurerm_key_vault_access_policy" "policy1" {
  key_vault_id = module.akv.akv_out.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = "42998f35-530e-4f84-a028-76bc0bd57695"

    key_permissions = [
      "Create",
      "Get",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List",
    ]

    storage_permissions = [
      "Get",
    ]
}

#add secret
resource "azurerm_key_vault_secret" "akv_secret" {
  name         = "secret-sauce"
  value        = "szechuan"
  key_vault_id = module.akv.akv_out.id
  depends_on = [
    module.akv
  ]
}
*/

module "vnetmodule" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VirtualNetwork/"
  virtual_network_name         = "avavnet"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  address_space = ["10.0.0.0/16"]
  subnet_definition = [{
    name = "subnetI"
    prefix = ["10.0.0.0/24"]
    service_endpoints = []
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = false
    delegations = []
  },{
    name = "subnetII"
    prefix = ["10.0.1.0/24"]
    service_endpoints = ["Microsoft.Sql","Microsoft.AzureActiveDirectory"]
    enforce_private_link_endpoint_network_policies = false
    enforce_private_link_service_network_policies = false
    delegations = ["Microsoft.Sql/managedInstances"]
  }]
  tags         = {
    environment = "sandbox"
  }
  #dns_servers   = ["10.0.0.4"]
  azure_monitor = module.azure_monitor
  #network_watcher_name = "NetworkWatcher_australiaeast"
  #network_watcher_resource_group_name = "NetworkWatcherRG"
  #ddos_protection_plan_id = azurerm_network_ddos_protection_plan.ddos.id
}

#add test rule on top of default rules
resource "azurerm_network_security_rule" "testRule" {
  name                        = "testRule"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.avatest.name
  network_security_group_name = "subnetI_NSG"
  depends_on = [
    module.vnetmodule
  ]
}

resource "azurerm_network_security_rule" "testRule2" {
  name                        = "testRule2"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.avatest.name
  network_security_group_name = "subnetI_NSG"
  depends_on = [
    module.vnetmodule
  ]
}
/*
resource "azurerm_user_assigned_identity" "vmuai" {
  resource_group_name = azurerm_resource_group.avatest.name
  location            = "Australia East"
  name = "vm-uai"
}
*/
module "lb"{
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//LoadBalancer/"
  name  = "avatestlb"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  sku = "Standard"
  frontend_ip_configurations=[{
    name = "fip"
    private_ip_address = null
    public_ip_address_id = null
    public_ip_prefix_id = null
    zones = null
    subnet_id = module.vnetmodule.subnets_out[0].id
    gateway_load_balancer_frontend_ip_configuration_id = null
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version = null
  }]
  /*
  nat_configurations=[{
    name = "linvm"
    network_interface_id  = module.linvm.vm_nics_out[0].id
    ip_configuration_name = module.linvm.vm_nics_out[0].ip_configuration[0].name
    frontend_ip_configuration_name = "avatestlb-fip"
    protocol = "Tcp"
    frontend_port = "22"
    backend_port = "22"
  }]

  backendpool_configuration={
    name = "vmpool2"
    network_interface_ids  = ["${module.linvm.vm_nics_out[0].id}","${module.winvm.vm_nics_out[0].id}"]
    ip_configuration_names = ["${module.linvm.vm_nics_out[0].ip_configuration[0].name}", "${module.winvm.vm_nics_out[0].ip_configuration[0].name}"]
    frontend_ip_configuration_name = "avatestlb-fip"
    probe_protocol = "Https"
    protocol = "Tcp"
    frontend_port = "443"
    backend_port = "443"
  }*/
}
/*
resource "azurerm_lb_backend_address_pool" "vmpool" {
  loadbalancer_id = module.lb.lb_out.id
  name            = "vmpool"
}

resource "azurerm_network_interface_backend_address_pool_association" "winvmbackend" {
  network_interface_id  = module.winvm.vm_nics_out[0].id
  ip_configuration_name = module.winvm.vm_nics_out[0].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.vmpool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "linvmbackend" {
  network_interface_id  = module.linvm.vm_nics_out[0].id
  ip_configuration_name = module.linvm.vm_nics_out[0].ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.vmpool.id
}

resource "azurerm_public_ip" "publicip" {
  name                = "VMPublicIp1"
  resource_group_name = azurerm_resource_group.avatest.name
  location            = "Australia East"
  allocation_method   = "Static"
}
*/
module "winvm" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VirtualMachineWindows/"
  name  = "avatestwin"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  size = "Standard_A2_v2"
  tags         = {
    environment = "sandbox"
  }
  azure_monitor = module.azure_monitor
  data_disks=[{
    name="D"
    size="10"
  }
  ]
  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
  vm_nics = [
    {
    subnet_id = module.vnetmodule.subnets_out[0].id
    private_ip_address = null
    private_ip_address_version= "IPv4"
    public_ip_address_id = null
    }
  ]
  source_image_reference= {
    offer     = "WindowsServer"
    publisher = "MicrosoftWindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk={
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = null
    write_accelerator_enabled = null
    disk_encryption_set_id = null
    security_encryption_type = null
    secure_vm_disk_encryption_set_id = null
    diff_disk_settings = {
      option = null
      placement = null
    }
  }
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "linvm" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VirtualMachineLinux/"
  name  = "avatestlin"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  size = "Standard_A2_v2"
  tags         = {
    environment = "sandbox"
  }
  azure_monitor = module.azure_monitor
  data_disks=[{
    name="D"
    size="10"
  }
  ]
  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
  admin_ssh_key = tls_private_key.example_ssh.public_key_openssh
  vm_nics = [
    {
    subnet_id = module.vnetmodule.subnets_out[0].id
    private_ip_address = null
    private_ip_address_version= "IPv4"
    public_ip_address_id = null
    }
  ]
  source_image_reference= {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
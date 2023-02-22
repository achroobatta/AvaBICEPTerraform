terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.13.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
}
}
resource "azurerm_resource_group" "avatest1" {
  name     = "avatest1"
  location = "Australia East"
}
resource "azurerm_virtual_network" "Hub-Vnet-Region1" {
  name = "Hub-Vnet-Region1"
  resource_group_name = azurerm_resource_group.avatest1.name
  location            = azurerm_resource_group.avatest1.location
  tags                = {
        environment = "sandbox"
    }
  address_space = ["10.1.0.0/16"]
    
}   
resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.avatest1.name
  virtual_network_name = azurerm_virtual_network.Hub-Vnet-Region1.name
  address_prefixes     = ["10.1.1.0/26"]
}
resource "azurerm_subnet" "GatewaySubnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.avatest1.name
  virtual_network_name = azurerm_virtual_network.Hub-Vnet-Region1.name
  address_prefixes     = ["10.1.2.0/27"]
}
#------------------------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "avatest2" {
  name     = "avatest2"
  location = "Australia East"
}
resource "azurerm_virtual_network" "Identity-VNET" {
  name                = "Identity-VNET"
  location            = azurerm_resource_group.avatest2.location
  resource_group_name = azurerm_resource_group.avatest2.name
  address_space       = ["10.2.0.0/16"]
  tags                = {
        environment = "sandbox"
    }
}

resource "azurerm_subnet" "ADDSSubnet" {
  name                 = "ADDSSubnet"
  resource_group_name  = azurerm_resource_group.avatest2.name
  virtual_network_name = azurerm_virtual_network.Identity-VNET.name
  address_prefixes     = ["10.2.1.0/24"]
}
resource "azurerm_virtual_network_peering" "example-1" {
  name                      = "HubtoIdentity"
  resource_group_name       = azurerm_resource_group.avatest1.name
  virtual_network_name      = azurerm_virtual_network.Hub-Vnet-Region1.name
  remote_virtual_network_id = azurerm_virtual_network.Identity-VNET.id
}

resource "azurerm_virtual_network_peering" "example-2" {
  name                      = "IdentitytoHub"
  resource_group_name       = azurerm_resource_group.avatest2.name
  virtual_network_name      = azurerm_virtual_network.Identity-VNET.name
  remote_virtual_network_id = azurerm_virtual_network.Hub-Vnet-Region1.id
}
#---------------------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "avatest3" {
  name     = "avatest3"
  location = "Australia East"
}
resource "azurerm_virtual_network" "LandingZone-VNET-A2" {
  name                = "LandingZone-VNET-A2"
  location            = azurerm_resource_group.avatest3.location
  resource_group_name = azurerm_resource_group.avatest3.name
  address_space       = ["10.3.0.0/16"]
  tags                = {
        environment = "sandbox"
    }
}
resource "azurerm_subnet" "LoadBalancer-Subnet" {
  name                 = "LoadBalancer-Subnet"
  resource_group_name  = azurerm_resource_group.avatest3.name
  virtual_network_name = azurerm_virtual_network.LandingZone-VNET-A2.name
  address_prefixes     = ["10.3.1.0/24"]
}
resource "azurerm_subnet" "App-Subnet" {
  name                 = "App-Subnet"
  resource_group_name  = azurerm_resource_group.avatest3.name
  virtual_network_name = azurerm_virtual_network.LandingZone-VNET-A2.name
  address_prefixes     = ["10.3.2.0/24"]
}
resource "azurerm_subnet" "DB-Subnet" {
  name                 = "DB-Subnet"
  resource_group_name  = azurerm_resource_group.avatest3.name
  virtual_network_name = azurerm_virtual_network.LandingZone-VNET-A2.name
  address_prefixes     = ["10.3.3.0/24"]
}
resource "azurerm_virtual_network_peering" "Hub-to-Landing" {
  name                      = "HubtoLanding"
  resource_group_name       = azurerm_resource_group.avatest1.name
  virtual_network_name      = azurerm_virtual_network.Hub-Vnet-Region1.name
  remote_virtual_network_id = azurerm_virtual_network.LandingZone-VNET-A2.id
}

resource "azurerm_virtual_network_peering" "Landing-to-Hub" {
  name                      = "LandingtoHub"
  resource_group_name       = azurerm_resource_group.avatest3.name
  virtual_network_name      = azurerm_virtual_network.LandingZone-VNET-A2.name
  remote_virtual_network_id = azurerm_virtual_network.Hub-Vnet-Region1.id
}
#------------------------------------------------------------------------------------------------------
resource "azurerm_resource_group" "avatest4" {
  name     = "avatest4"
  location = "Australia East"
}
resource "azurerm_virtual_network" "LandingZone-VNET-A1" {
  name                = "LandingZone-VNET-A1"
  location            = azurerm_resource_group.avatest4.location
  resource_group_name = azurerm_resource_group.avatest4.name
  address_space       = ["10.4.0.0/16"]
  tags                = {
        environment = "sandbox"
    }
}
resource "azurerm_subnet" "LoadBalancer1-Subnet" {
  name                 = "LoadBalancer1-Subnet"
  resource_group_name  = azurerm_resource_group.avatest4.name
  virtual_network_name = azurerm_virtual_network.LandingZone-VNET-A1.name
  address_prefixes     = ["10.4.1.0/24"]
}
resource "azurerm_subnet" "App1-Subnet" {
  name                 = "App1-Subnet"
  resource_group_name  = azurerm_resource_group.avatest4.name
  virtual_network_name = azurerm_virtual_network.LandingZone-VNET-A1.name
  address_prefixes     = ["10.4.2.0/24"]
}
resource "azurerm_subnet" "DB1-Subnet" {
  name                 = "DB1-Subnet"
  resource_group_name  = azurerm_resource_group.avatest4.name
  virtual_network_name = azurerm_virtual_network.LandingZone-VNET-A1.name
  address_prefixes     = ["10.4.3.0/24"]
}
resource "azurerm_virtual_network_peering" "Hub-to-Landing2" {
  name                      = "HubtoLanding2"
  resource_group_name       = azurerm_resource_group.avatest1.name
  virtual_network_name      = azurerm_virtual_network.Hub-Vnet-Region1.name
  remote_virtual_network_id = azurerm_virtual_network.LandingZone-VNET-A1.id
}

resource "azurerm_virtual_network_peering" "Landing2-to-Hub" {
  name                      = "Landing2toHub"
  resource_group_name       = azurerm_resource_group.avatest4.name
  virtual_network_name      = azurerm_virtual_network.LandingZone-VNET-A1.name
  remote_virtual_network_id = azurerm_virtual_network.Hub-Vnet-Region1.id
}
#--------------------------------------------------------------------------------------------------
#Azure Virtual Wan
resource "azurerm_virtual_wan" "vwan" {
  name                = "avatest-virtualwan"
  resource_group_name = azurerm_resource_group.avatest1.name
  location            = azurerm_resource_group.avatest1.location
}
# Azure Virtual hub
resource "azurerm_virtual_hub" "vhub" {
  name                = "avatest-virtualhub"
  resource_group_name = azurerm_resource_group.avatest1.name
  location            = azurerm_resource_group.avatest1.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.0.0.0/23"
  tags                = {
        environment = "sandbox"
    }
}
# Public IP
resource "azurerm_public_ip" "publicip" {
  name                = "testpip"
  location            = azurerm_resource_group.avatest1.location
  resource_group_name = azurerm_resource_group.avatest1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Azure Firewall
resource "azurerm_firewall" "fw" {
  name                = "testfirewall"
  location            = azurerm_resource_group.avatest1.location
  resource_group_name = azurerm_resource_group.avatest1.name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  tags                = {
        environment = "sandbox"
    }
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.AzureFirewallSubnet.id
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}
# Public IP
resource "azurerm_public_ip" "publicip2" {
  name                = "testpip2"
  location            = azurerm_resource_group.avatest1.location
  resource_group_name = azurerm_resource_group.avatest1.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones = ["1"]
}
#Azure VPN Gateway
resource "azurerm_virtual_network_gateway" "vpn" {
  name                = "Test-VPN-Gateway"
  location            = azurerm_resource_group.avatest1.location
  resource_group_name = azurerm_resource_group.avatest1.name
  sku                 = "VpnGw1AZ"
  type                = "Vpn"
  vpn_type = "RouteBased"
  active_active = false
  tags                = {
        environment = "sandbox"
    }
  ip_configuration {
    name = "vpnGatewayConfig"
    subnet_id = azurerm_subnet.GatewaySubnet.id
    public_ip_address_id = azurerm_public_ip.publicip2.id
  }
}
resource "azurerm_public_ip" "publicip1" {
  name                = "testpip1"
  location            = azurerm_resource_group.avatest1.location
  resource_group_name = azurerm_resource_group.avatest1.name
  allocation_method   = "Static"
  sku                 = "Standard"
}
# Azure Express Route Gateway
resource "azurerm_virtual_network_gateway" "exproute" {
  name                = "Test-Exp-Route"
  location            = azurerm_resource_group.avatest1.location
  resource_group_name = azurerm_resource_group.avatest1.name
  sku                 = "Standard"
  type                = "ExpressRoute"
  active_active = false
  tags                = {
        environment = "sandbox"
    }
  ip_configuration {
    name = "exprouteGatewayConfig"
    subnet_id = azurerm_subnet.GatewaySubnet.id
    public_ip_address_id = azurerm_public_ip.publicip1.id
  }
}
resource "azurerm_network_interface" "nic-DC1" {
  name                = "nic-DC1"
  location            = azurerm_resource_group.avatest2.location
  resource_group_name = azurerm_resource_group.avatest2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ADDSSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_network_interface" "nic-DC2" {
  name                = "nic-DC2"
  location            = azurerm_resource_group.avatest2.location
  resource_group_name = azurerm_resource_group.avatest2.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ADDSSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_windows_virtual_machine" "DC1" {
  name                = "DC1"
  resource_group_name = azurerm_resource_group.avatest2.name
  location            = azurerm_resource_group.avatest2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic-DC1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_windows_virtual_machine" "DC2" {
  name                = "DC2"
  resource_group_name = azurerm_resource_group.avatest2.name
  location            = azurerm_resource_group.avatest2.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.nic-DC2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "DC1" {
  name                 = "disk1"
  location             = azurerm_resource_group.avatest2.location
  resource_group_name  = azurerm_resource_group.avatest2.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}
resource "azurerm_managed_disk" "DC2" {
  name                 = "disk2"
  location             = azurerm_resource_group.avatest2.location
  resource_group_name  = azurerm_resource_group.avatest2.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 10
}
resource "azurerm_virtual_machine_data_disk_attachment" "DC1" {
  managed_disk_id    = azurerm_managed_disk.DC1.id
  virtual_machine_id = azurerm_windows_virtual_machine.DC1.id
  lun                = "0"
  caching            = "None"
}
resource "azurerm_virtual_machine_data_disk_attachment" "DC2" {
  managed_disk_id    = azurerm_managed_disk.DC2.id
  virtual_machine_id = azurerm_windows_virtual_machine.DC2.id
  lun                = "0"
  caching            = "None"
}
module "lb"{
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//LoadBalancer/"
  name  = "avatestlb1"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest3.name
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
    subnet_id = azurerm_subnet.LoadBalancer-Subnet.id
    gateway_load_balancer_frontend_ip_configuration_id = null
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version = null
  }]
}
module "lb2"{
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//LoadBalancer/"
  name  = "avatestlb2"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest4.name
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
    subnet_id = azurerm_subnet.LoadBalancer1-Subnet.id
    gateway_load_balancer_frontend_ip_configuration_id = null
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version = null
  }]
}
# Introduction 
Azure Bastion is a service you deploy that lets you connect to a virtual machine using your browser and the Azure portal. The Azure Bastion service is a fully platform-managed PaaS service that you provision inside your virtual network. It provides secure and seamless RDP/SSH connectivity to your virtual machines directly from the Azure portal over TLS. When you connect via Azure Bastion, your virtual machines don't need a public IP address, agent, or special client software.

Bastion provides secure RDP and SSH connectivity to all of the VMs in the virtual network in which it is provisioned. Using Azure Bastion protects your virtual machines from exposing RDP/SSH ports to the outside world, while still providing secure access using RDP/SSH.

| Version | Date | Release Notes | Author |
|---|---|---|--|
| 1.0 | July22 | First release | jenay.jeeva |

# Module Dependencies
- VirtualNetwork

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|--|
| location | Location to deploy resources |  string |
| nsgName | The name of the network security group associated with the Bastion Subnet | string |
| vnetName | The name of the virtual network for the resource | string |
| publicIpAddressName | The public IP address name of the Bastion Host | string |
| bastionSubnetIpPrefix | The Subnet IP address prefix of the Bastion Host Subnet (requires a subnet mask of at least 27 bits) | string |
| bastionHostName | The name of the Bastion Host resource | string | 


# Optional Parameters
There are some optional parameters which have some default values entered. 

# References
- [Quickstart: Deploy Azure Bastion in a virtual network using an ARM template](https://docs.microsoft.com/en-us/azure/bastion/quickstart-host-arm-template)
- [What is Azure Bastion?](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview)
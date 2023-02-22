# Introduction 
The Domain Name System, or DNS, is responsible for translating (or resolving) a service name to an IP address. Azure DNS is a hosting service for domains and provides naming resolution using the Microsoft Azure infrastructure. Azure DNS not only supports internet-facing DNS domains, but it also supports private DNS zones.

Azure Private DNS provides a reliable and secure DNS service for your virtual network. Azure Private DNS manages and resolves domain names in the virtual network without the need to configure a custom DNS solution. By using private DNS zones, you can use your own custom domain name instead of the Azure-provided names during deployment. Using a custom domain name helps you tailor your virtual network architecture to best suit your organization's needs. It provides a naming resolution for virtual machines (VMs) within a virtual network and connected virtual networks. Additionally, you can configure zones names with a split-horizon view, which allows a private and a public DNS zone to share the name.

| Version | Date | Release Notes | Author |
|---|---|---|
| 1.0 | July22 | First release | jenay.jeeva |

# Module Dependencies
- VirtualNetwork

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|
| location | Location for all resources |  string |
| privateDnsZoneName | The name of the private DNS Zone for managing and resolving domain names | string |
| vnetName | The virtual network to link with the Private DNS Zone | string |
| vmRegistration | A toggle choice for auto-registration of virtual machine records in the virtual network in the Private DNS zone | bool |

# Optional Parameters
| Parameter Name | Description | Type | 
There are no optional parameters. 

# References
- [Microsoft.Network privateDnsZones/virtualNetworkLinks](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/privatednszones/virtualnetworklinks?pivots=deployment-language-arm-template)
- [Quickstart: Create an Azure DNS zone and record using an ARM template](https://docs.microsoft.com/en-us/azure/dns/dns-get-started-template)
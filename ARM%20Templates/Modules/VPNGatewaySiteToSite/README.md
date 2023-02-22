# Introduction 
VPN Gateway sends encrypted traffic between an Azure virtual network and an on-premises location over the public Internet. You can also use VPN Gateway to send encrypted traffic between Azure virtual networks over the Microsoft network. A VPN gateway is a specific type of virtual network gateway. 

- There are different configurations available for VPN gateway connections. Out of the configuration designs listed below, this template will deploy **Site to Site VPN gateway**:
  - Site to Site VPN
  - Point to Site VPN
  - VNet-to-VNet connections (IPsec/IKE VPN tunnel)
  - Site-to-Site and ExpressRoute coexisting connections

- <img src="../../img/sitetosite_vpngateway-diagram.png" width=800>




## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | su.myat.khine.win |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |




## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
|vNETCopyIndex| Virtual Network|1.0|
|publicIPAddress| Public IP addresses allow Internet resources to communicate inbound to Azure resources. Public IP addresses enable Azure resources to communicate to Internet and public-facing Azure services. The public IP Address is required for VPN Gateway.|1.0|

### Create resources using Azure cli and Azure Powershell commands 
- [See this document for configuring a virtual private network gateway site to site connection using PowerShell](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-create-site-to-site-rm-powershell):
- [See this document for configuring a virtual private network gateway site to site connection using Cli](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-howto-site-to-site-resource-manager-cli):


## Required Parameters


| Parameter Name | Description |  Type | 
|---|---|---|
|vpnType| It needs to be either Route Based or policy based|string|string | 
|localGatewayName|"Arbitrary name for gateway resource representing. This local gateway will connect with VPN devices on premises|string | 
|localGatewayIpAddress|Public IP of your StrongSwan Instance|string | 
|localAddressPrefix|CIDR block representing the address space of the OnPremise VPN network's Subnet|array| 
|virtualNetworkName|Arbitrary name for public IP resource used for the new azure gateway|string | 
|gatewayName|Arbitrary name for the new gateway|string | 
|gatewaySku|The Sku of the Gateway. This must be one of Basic, Standard or HighPerformance.|string | 
|connectionName|Arbitrary name for the new connection between Azure VNet and other network|string | 
|sharedKey|Shared key (PSK) for IPSec tunnel|string | 
|location|Resource group location|string | 


## Optional/Advance Parameters

There are no advance or optional Parameters.



## Additional details
### Sample usage when using this module in your own modules

```

```

## References

- [About ExpressRoute virtual network gateways](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-about-virtual-network-gateways)
- [Tutorial: Create and manage a VPN gateway using the Azure portal](https://docs.microsoft.com/en-us/azure/vpn-gateway/tutorial-create-gateway-portal)
- [Quickstart: Create an ExpressRoute circuit with private peering using an ARM template](https://docs.microsoft.com/en-us/azure/expressroute/quickstart-create-expressroute-vnet-template)
- Videos resources
    -


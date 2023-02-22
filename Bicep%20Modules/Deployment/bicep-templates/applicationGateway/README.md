# Introduction 
It deploys Application gateway with pubIp to the resource group. It is recommended that gateways should have its own vnet/subnet.

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | September 22 | First release | Prahash Indorkar |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
- Resource Group
- Vnet
- Subnet
- PublicIP 


### Create resources using Azure cli and Azure Powershell commands 
- appGateway.withWAF.bicep template creates resources requred to test WAF functionality of Application gatway
-- 2 VMs with IIS installed
-- 2 Public IPs (1 for each VM)
-- 2 NSGs
-- 1 vNet for Application Gateway
-- 2 subnets along ( 1 for App Gateway and other for 2 Vms)
-- 2 NICs for each VM


## Required Parameters

| Parameter Name (Type): Description
|---|---|---|---|
| appGatewayName (string): Name of Appgateway
| appGatewaySKU (string): Application gateway sku
| appGatewayTier (string): Application gateway tier
| zoneRedundant (bool): Enable Azure availabilty zone redundancy
| publicIpAddressName (string): Public IP address resource name
| vNetResourceGroup (string): Resource group name of Virutal network
| vNetName (string): Virtual Networking name for Application Gateway
| subnetName (string): Subnet name for Application Gateway 
| frontEndPorts (array): Array containing front end ports
| httpListeners (array): Array containing http listeners
| backendAddressPools (array): Array containing backend address pools
| backendHttpSettings (array): Array containing backend http settings
| requestRoutingRules (array): Array containing request routing rules



## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs

| Parameter Name (Type): Description 
|---|---|---|
| name (string): Application Gateway Name
| id (string): Application Gateway ID
| publicIpAddress (string): Public IP address of Application Gateway


|  |  |  |

## Additional details
### Sample usage when using this module in your own modules


## References
- [Azure Application Gateway](https://github.com/ArtiomLK/azure-bicep-application-gateway/tree/main)


# Introduction 
It deploys Application gateway with pubIp to the resource group. It is recommended that gateways should have its own vnet/subnet.

| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | Vinita Bhasin |

# Module Dependencies
- Vnet
- Subnet
- PublicIP 

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|---|
| appGatewayName | name of Appgateway | string |
| vnetName | vnet name | string |
| subnetName | Subnet name | string |
| pubIPName | public Ip name | string |
| backendIPAddresses | backend IP addresses | array |



# Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

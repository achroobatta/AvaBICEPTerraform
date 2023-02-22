# Introduction 
This template will deploy a VPN Gateway.

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release |  |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
| vnet | Virtual network module | | 
| subNet | subnets module | | 
| storageAccount | Storage account to store logs |  |
| publicIP | Public ip address |  |
| logAnalyticsWorkspace | log analytics module |  |


## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| name | name of the VPN Gateway | string |
| pipName | name of teh public IP | string |
| vnetName | name of the Vnet | string |
| location | location of the resource | string | 
| tags | tags for the resource | object |
| sku | sku for the vpn | string |
| vpnGatewayGeneration | vpn gateway generation | string | 
| vpnType | type of vpn | string |
| aadAudience | aad audience | string | 
| aadIssuer | aad issuer | string | 
| aadTenant | aad tenant | string |
| addressPrefixes | address prefix | string |
| vpnClientProtocols | vpn client protocols | string |
| vpnAuthenticationTypes | authentication type for vpn | string | 

## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

## Additional details
### Sample usage when using this module in your own modules

```

```

## References

- what is VPN Gateway?  https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpngateways



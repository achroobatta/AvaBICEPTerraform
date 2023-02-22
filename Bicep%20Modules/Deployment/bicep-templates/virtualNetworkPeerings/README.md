# Introduction 
This template will create virtual network peering.

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


## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| spokeVirtualNetworkName | name of the spoke vnet | string | 
| spokeVirtualNetworkGroup | spoke vnet group | string | 
| hubVirtualNetworkName | name of the hub vnet | string |
| hubVirtualNetworkGroup | hub vnet group name | string |
| allowVirtualNetworkAccess | allow vnet access | boolean | 
| allowForwardedTraffic | allow traffic forwarding? | boolean | 
| allowGatewayTransit | allow gateway transit | boolean | 
| useRemoteGateways | use Remote Gateways | boolean | 

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

- https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-peering

- https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/hybrid-networking/vnet-peering



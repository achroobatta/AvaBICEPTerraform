# Introduction 
It deploys Express Route Circuit. Another template is used to create Private peering to Express route. 


## Version
| Version | Date | Release Notes | Author
|---|---|---|---|
| 1.0.0 | Aug22 | First release | Rama Balla


## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0.0 | |


# Required Parameters
| Parameter Name | Description | Type | Default value |
|---|---|---|---|
| circuitName | Circuit name  | string | er-ckt01
| location | region | string | Australi East |
| serviceProviderName | Provder Name | string | Equinix
| peeringLocation | Peering Location | string | Silicon Valley
| bandwidthInMbps | bandwidthInMbps | int | 500


# Module Dependencies
- In order to create Private Peering to Express Route, ER Circuit must be created first


## Optional/Advance Parameters
- There are no advance or optional Parameters.

## Outputs
- There are no outputs.


## Additional details
- None


## References
- [Create an Express Route Circuit - Azure Portal](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-circuit-portal-resource-manager)
- [Create an Express Route Circuit - Azure PowerShell](https://docs.microsoft.com/en-us/azure/expressroute/expressroute-howto-circuit-arm)
- [Create an Express Route Circuit - Azure CLI](https://docs.microsoft.com/en-us/azure/expressroute/howto-circuit-cli)
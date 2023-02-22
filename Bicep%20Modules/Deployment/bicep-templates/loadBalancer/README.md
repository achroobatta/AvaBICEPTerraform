# Introduction 
This template will deploy an Azure Load Balancer.
## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
| vNet | Provision virtual network |  |
| Subnet | Provision subnet | |


## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| loadBalancerName | name of the load balancer | string |
| location | location of the resource | string |
| tags | tags for the resource | object | 
| loadBalancerSKU | sku of the load balancer | string |
| loadBalancerTier | load balancer tier | string |
| loadBalancerFrontEndIPConfigName | frontend IP name | string |
| loadBalancerFrontEndIP | Frontned Ip address | string | 
| loadBalancerBackEndPoolName | backend pool name | string |
| loadBalancerRules | load balancing rules | object | 
| loadBalancerProbes | required probes for load balancer | object | 
| loadBalancerInboundNatRules | Inbound NAT rules | object | 
| loadBalancerInboundNatRule | enable lb inbound NAT rule? | boolean | 
| loadBalancerInboundNatPools | inbound NAT pools | object |
| loadBalancerInboundNatPool | enable inbound NAT pool? | boolean | 
| loadBalancerBackendVMs | backend vms | array | 
## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs
| Output Name | Description | Type | 
|---|---|---|
| loadBalancerName | name of the load balancer | string |
| loadBalancerBackendPoolName | name of the backend pool | string |


## Additional details
### Sample usage when using this module in your own modules

```

```

## References

- What is Azure Loab Balancer? https://docs.microsoft.com/en-us/azure/load-balancer/load-balancer-overview

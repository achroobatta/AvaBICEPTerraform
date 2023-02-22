# Introduction 
This template will deploy an Azure Internal Load Balancer in the resource group.

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | Aug22 | First release | su.myat.khine.win |

---

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |

---

## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
|SQL Server|Create the SQL server which acts as a Logical server.||

---

### Create resources using Azure cli and Azure Powershell commands 
- [See this document for creating the SQL single database via Azure PowerShell](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-internal-powershell)
- [See this document for creating the SQL single database via Azure Cli](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-internal-cli)

---

## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| adminUsername | Admin username |  string |
| adminPassword | Admin username |  secureString|
|backendAddressPools|The name of the backend address pool|string |
|frontendIPConfigurationsName|The name of the frontend IP configuration|string |
|vmNamePrefix|Prefix to use for VM names|string |
|location|Location for all resources.|string |
|loadbalancerProbeName|The name of the frontend IP configuration|string |
|loadbalancerRuleName|A load balancer rule is used to define how incoming traffic is distributed to the all the instances within the backend pool.|string |
|numberOfProbes|Number of failed probes before the node is determined to be unhealthy|string |
|privateIPAddress|Private IP Address range. Do not use the 1st and last IP addresses: 1st IP of the range - use for identification. last IP is for broadcast|string |
|privateIPAllocationMethod|The Private IP allocation method|string |
|protocol|Protocol is an established set of rules that determine how data is transmitted between different devices in the same network.|string |
|portNumber|System/Internet HTTP port|int |
|subnetName|The name of the subnet|string |
|vmSize|Size of the virtual machines|string |
|vnetName|The name of the virtual network|string |

---

## Optional/Advance Parameters

There are no advance or optional Parameters.

---

## Outputs
There are no outputs.

## Additional details
### Sample usage when using this module in your own modules

---

## References

- [Quickstart: Create an internal load balancer to load balance VMs using the Azure portal](https://docs.microsoft.com/en-us/azure/load-balancer/quickstart-load-balancer-standard-internal-portal)
- [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) 

- Videos resources
    - [Getting Started with DevOps for Azure SQL | Data Exposed](https://www.youtube.com/watch?v=j7OnxOz7YDY&t=0s)
    - []()
---

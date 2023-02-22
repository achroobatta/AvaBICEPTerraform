# Introduction 
This template will deploy a Windows virtual machine.

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
| NiC | Network interface |  |
| logAnalyticsWorkspace | log analytics module |  |


## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| adminUserName | admin username for the vm | string |
| adminPassword | admin passowrd for the vm | string |
| name | name of the vm | string | 
| osType | type of OS | string |
| vmSize | size of the vm | string |
| imageReference | vm image | object | 
| privateIPAddressVersion | private IP address version | string | 
| availabilitySet | name of the availability set | string | 
| virtualNetwork | name of the vnet | string |
| subnet | name of the subnet | string | 
| applicationSecurityGroup | name of the application security group | string | 
| storageAccountType | type of storage | string |
| disks | disks to be attached to the vm | object | 


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

- Windows vm overview: https://azure.microsoft.com/en-au/services/virtual-machines/windows/#product-overview



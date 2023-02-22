# Introduction 
This template will deploy a private DNS template.

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
| vnet | Virtual network module | | 


## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| privateDnsZoneName | name of the private DNS | string | 
| location | location of the resource | string |
| enableVnetLink | Link Private Dns Zone to an existing Virtual Network? | boolean |
| vnetResourceId | Virtual network id | string |
| registrationEnabled | Enable auto-registration of virtual machine records for Private Dns Zone | boolean | 


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

- [azure-bicep-private-dns-zone/private-dns-zone.bicep](https://github.com/tw3lveparsecs/azure-bicep-private-dns-zone/blob/main/private-dns-zone.bicep)



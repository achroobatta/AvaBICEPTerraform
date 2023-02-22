# Introduction 
It deploys Azure Active Directory Domain Service to the resource group. This folder contains the nsg rules which will be attached to domain subnet. It is recommended that Active directory should have its own vnet/subnet.
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | Vinita Bhasin |

# Module Dependencies
- Vnet
- Subnet
- Nsg 

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|---|
| domainName | name of domain | string |
| vnetName | vnet name | string |
| subnetName | Subnet name | string |



# Optional Parameters
| Parameter Name | Description | Type | 
There are some optional parameters which have some default values entered. 

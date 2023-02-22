# Introduction 
Create Private DNS zone with option to attach virtual network for autoregistration.
SOA record tags will always align with the Private DNS zone tags.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | July22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
There are no dependencies

| Module Name | Description | Tested Version |
|---|---|---|


# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| name | Name of the DNS zone | string |
| resource_group_name | Name of the RG | string |
| tags | Azure Tags | map |



# Optional/Advance Parameters
Reference for DNS private zone resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone

Reference for DNS private zone virtual network link resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| soa_record | SOA record block. Tags are not exposed and always uses the DNS private zone tags | null | object({<br/>email = string<br/>expire_time = number<br/>minimum_ttl = number<br/>refresh_time = number<br/>retry_time = number<br/>ttl = number<br/>}) |
| virtual_network_ids | virtual_network_ids to link to the private dns zone | null | list(object({<br/>id= string<br/>registration_enabled = bool<br/>})) |


# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| zone_out | Output of private DNS zone object | any |

# Additional details
## Simple code sample
```
module "privatednszone" {
  source              = "./PrivateDNSZone"
  name = "mydomaintest.com"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
}
```
## Sample creation of DNS zone with custom SOA and 2 vnet integration
```
module "privatednszone" {
  source              = "./PrivateDNSZone"
  name = "mydomaintest.com"
  resource_group_name = azurerm_resource_group.avatest.name
  tags         = {
    environment = "sandbox"
  }
  virtual_network_ids = [{
    id = module.vnetmodule.vnet_out.id
    registration_enabled = true
  },
  {
    id = azurerm_virtual_network.example.id
    registration_enabled = true
  }]
  soa_record = {
    email = "admin.test.com"
    expire_time = 2419200
    minimum_ttl = 10
    refresh_time = 3600
    retry_time = 300
    ttl = 3600
  }
}
```
## Sample creation of DNS records in the zone
Below show the creation of a record, use the same method for other types of DNS records using the respective resource providers.
```
resource "azurerm_private_dns_a_record" "example" {
  name                = "test"
  zone_name           = module.privatedns.zone_out.name
  resource_group_name = azurerm_resource_group.avatest.name
  ttl                 = 300
  records             = ["10.0.180.17"]
}
```

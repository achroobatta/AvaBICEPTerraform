# Introduction 
This module MSSQL Managed instances.
MSSQL failover group is provisioned in this module.
Subnet route table association and provisioning a route table are included in this module. Further customising the route table options is beyond this module.
Azure monitor onboarding module is imported into this to configure the logs and metrics.
Provisioning vulnerability assessment rules are beyond this module. These features seem to be tied with "Microsoft defender subscription".

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | August22 | First release | santosh.manne |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
| Module Name | Description | Tested Version |
|---|---|---|
| AzureMonitor | Required provisioning of required log analytics, event hub and storage account required for diagnostics logging | 1.0 |
| AzureMonitorOnboarding | Optional onboard and configure diagnostics to resources provisioned by AzureMonitor module | 1.1 |
| AzureKeyVault | Required provisioning for storing passwords securely | 1.0 |
| VirtualNetwork | Required to create vnet, subnets, nsgs, network security rules | 1.0 |


# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| password_akv_id | Azure Keyvault id | string | 
| password_akv_access_policy | Azure Keyvault password access policy | string |
| route_table_name | Name of the route table | string |
| subnet_id | Azure subnet module ourput | string |
| primary_instance_name | Name of the primary instance | string |
| secondary_instance_name | Name of the secondary instance | string |
| resource_group_name | Name of the resource group | string |
| location | Location of the primary Sql server | string |
| secondary_sqlserver_location | Secondary Sql server location | string |
| sqlserver_version | version of the Sql server | string | 
| admin_username | Sql server admin username | string |
| admin_password | Passowrd can either be given by the user or randonly generated | string |
| primary_instance_tags | Tags for the primary instance | map |
| secondary_instance_tags | Tags for the secondary instance | map |
| minimum_tls_version | minimum transport layer security version | number |
| db_names| database names | list["string1", "string2"] |
| collation | Collation required for the database | string |
| max_size_gb | Max size of the database | number |
| sku_name | SKU of the instance | string |
| license_type | Instance license type | string |
| storage_size_in_gb | storage size allocation | number |
| vcores | No.of cores to be assigned to the instance | number |
| faliover_group_name | Name of the failover group | string |
| read_write_endpoint_failover_policy | fail over policy config | object({<br/>mode = string<br/>grace_minutes = number<br/>}) |   
| readonly_endpoint_failover_policy_enabled | do you need the failover policy? | boolean | 




# Optional/Advance Parameters

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| disable_bgp_route_propagation | disable bgp route propagation? | false | boolean |
| dns_zone_partner_id | Id of the SQL Managed Instance | null | string |
| maintenance_configuration_name | Public Maintenance Configuration window to apply | null |
| proxy_override | specifies how the SQL Managed Instance will be accessed | Default | string |
| public_data_endpoint_enabled | Is the public data endpoint enabled? | false | boolean |
| storage_account_type | type of storage acc required | null | string |
| timezone_id | time zone the instance will operate in | UTC | string |
| identity | Identity block | null | object({<br/>type = string<br/>}) | 
| secondary_instance_name | secondary instance name if required | null | string |
| secondary_instance_required | Do you need a secondary instance? | false | boolean |
| azure_monitor | Azure monitor module output | null | |
| logging_retention | log retention days | 30 | number |



# Outputs
| Parameter Name | Description | Type | 
|---|---|---|
| primary_instance_out  | Output of primary managed instance | any |
| secondary_instance_out | Output of secondary managed instance | any |
| rt_out | Output of route table | any |
| rt_association | Output of route table association | any | 
|fail_over_group | Output of failover group | any |

# Reference
Azure MSSQL Managed Instance: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_managed_instance
Azure MSSQL Managed Instance Failover Group: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_managed_instance_failover_group
Info on route table: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/route_table
Info on Managed Instance vulnerability assessment: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_managed_instance_vulnerability_assessment

# Additional details
## Sample basic usage 
`resource "azurerm_resource_group" "avatest" {
  name     = "avatest"
  location = "Australia East"
```
module "AMSI" {
  source = "./AzureSQLManagedInstance/"
  primary_instance_name = "avatestmanagedinstance"
  location  = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  license_type       = "BasePrice"
  sku_name           = "GP_Gen5"
  storage_size_in_gb = 32
  subnet_id          = module.vnet.subnets_out[0].id
  vcores             = 4
  route_table_name = "routemeproper"
  primary_instance_tags = {
    environment = "sandbox"
  }
  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
}

```
## Sample usage with additional parameters and provisioning secondary instance and failover group
```
module "AMSI" {
  source = "./AzureSQLManagedInstance/"
  primary_instance_name = "avatestmanagedinstance"
  secondary_instance_required = true
  secondary_instance_name = "avatestsecondaryinstance2"
  location  = "Australia East"
  secondary_location = "East US"
  resource_group_name = azurerm_resource_group.avatest.name
  license_type       = "BasePrice"
  sku_name           = "GP_Gen5"
  storage_size_in_gb = 32
  subnet_id          = module.vnet.subnets_out[0].id
  vcores             = 4
  route_table_name = "routemeproper"
  primary_instance_tags = {
    environment = "sandbox"
  }
  secondary_instance_tags = {
    environment = "sandbox"
  }
  failover_group_name = "pleasedontfail"
  readonly_endpoint_failover_policy_enabled = true
  read_write_endpoint_failover_policy = {
    mode          = "Automatic"
    grace_minutes = 60
  }

  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
}
```

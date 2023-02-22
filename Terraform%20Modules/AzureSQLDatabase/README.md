# Introduction 
This module creates multiple Azure SQL servers and databases.
Sql server failover group is provisioned in this module.
Provisioning an elasti pool is also included in this module. Configuration of elastic pool is beyond this module.
Azure monitor onboarding module is imported into this to configure the logs and metrics.
Configuring mssql firewall rule is beyond the scope of this module. This may be dependent on the organisational security principles. Please refer to the resource provider documentation for details to configure this.
Configuring elastic job agent & job credential is not addressed in this module.
Provisioning extended auditing policies and vulnerability assessment rules are beyond this module. These features seem to be tied with "Microsoft defender subscription".

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.2 | Nov22 | Fix issue during failed destory where terraform index is broken during subsequent runs | viktor.lee |
| 1.1 | Nov22 | Fix issue where secondary server, failover group and elastic pool is mandatory and various other code issues | viktor.lee |
| 1.0 | July22 | First release | santosh.manne |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.2 | 1.3.4 | 3.30.0 |
| 1.1 | 1.3.3 | 3.30.0 |
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
| Module Name | Description | Tested Version |
|---|---|---|
| AzureMonitor | Required provisioning of required log analytics, event hub and storage account required for diagnostics logging | 1.0 |
| AzureMonitorOnboarding | Optional onboard and configure diagnostics to resources provisioned by AzureMonitor module | 1.1 |
| AzureKeyVault | Required provisioning for storing passwords securely | 1.0 |

# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| password_akv_id | Azure Keyvault id | string | 
| password_akv_access_policy | Azure Keyvault password access policy | string |
| primary_sqlserver_name | Name of the primary server | string |
| resource_group_name | Name of the resource group | string |
| location | Location of the primary Sql server | string |
| sqlserver_version | version of the Sql server | string | 
| tags | Tags for the Sql server | map {<br/>description = "(Required) map of tags"<br/>type = map<br/>} |
| minimum_tls_version | minimum transport layer security version | number |
| db_names| database names | list["string1", "string2"] |
| collation | Collation required for the database | string |
| sku_name | SKU of the database | string |
| db_tags | Tags for the database | map {<br/>description = "(Required) map of tags"<br/>type = map<br/>} |


# Optional/Advance Parameters

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| admin_username | Sql server admin username | sqladmin | string |
| admin_password | Passowrd can either be given by the user or randonly generated | null | string |
| secondary_sqlserver_name | Name of the secondary server | null | string |
| secondary_sqlserver_location | Secondary Sql server location | null | string |
| secondary_sqlserver_tags | Tags for the secondary Sql server | null | map {<br/>description = "(Required) map of tags"<br/>type = map<br/>} |
| elastic_pool_name | Name of the elastic pool | null | string |
| elastic_pool_sku | Elastic pool SKU | null | object({<br/>name = string<br/>capacity = number<br/>tier = string<br/>family = string<br/>}) |
| per_database_settings | Min & Max database capacities | null | object({<br/>min_capacity = number<br/>max_capacity = number<br/>}) |
| max_size_gb | Max size of the database | 10 | number |
| connection_policy | Sql server connection policy | Default |string | 
| public_network_access_enabled | enable public network access to sql server? | false | Boolean |
| outbound_network_restriction_enabled | whether outbound traffic from the server is resticted | false | Boolean |
| sqlid | Managed identity for the SQL server | null | object({<br/>type = string<br/>identity_ids = string<br/>}) | 
| sqlid_type | Type of managed identity | null | string |
| primary_user_assigned_identity_id | primary user managed identity id | null | string |
| azuread_administrator | Azure AD authentication | null | object({<br/>login_username = string<br/>object_id = string<br/>tenant_id = string<br/> azuread_authentication_only = bool<br/>}) | 
| dns_alias_names | specifies dns alias names | null | list["value1", "value2"] |
| license_type | License type for the database | LicenceIncluded | string |
| read_scale | read only connections redirected | false | Boolean |
| zone_redundant | replicas of databse to be spread accross multiple regions? | false | Boolean|
| auto_pause_delay_in_minutes | pause the database if unused for a certain period of time | 60 | Number |
| create_mode| create mode for the database | null | string |
| creation_source_database_id | source database (db) id to create a new db | null | string |
| elastic_pool_id | Elastic pool id | null | string |
| geo_backup_enabled | For enabling geo backup | false | Boolean |
| ledger_enabled | Is the db ledger enabled | false | Boolean |
| restore_point_in_time | point in time (ISO8601 format) of the source database to be restored from | null | string | 
| recover_database_id | The ID of the database to be recovered | null | string |
| restore_dropped_database_id | The ID of the database to be restored | null | string |
| read_replica_count | The number of readonly secondary replicas associated with the database | null | Number | 
| sample_name | name of the sample schema to apply when creating db | null | string |
| storage_account_type | name of the storage account | null | string |
| long_term_retention_policy | LTR policy to automatically retain backups | null | object({<br/>weekly_retention = string<br/>monthly_retention = string<br/>yearly_retention = string<br/>week_of_year = number<br/>}) |
| short_term_retention_policy | Short term retention policy configuration | null | object({<br/>retention_days = number<br/>backup_interval_in_hours = number<br/>}) |
| threat_detection_policy | Enable threat detection policy? | null | object({<br/>state = string<br/>disabled_alerts = string<br/>email_account_admins = list(string)<br/>email_addresses = list["string1", "string2"]<br/>retention_days = number<br/>storage_account_access_key = string<br/>storage_endpoint = string<br/> |
| azure_monitor | Azure monitor module output | null | |
| logging_retention | log retention days | 30 | number |
| elastic_pool_licence_type | license type applied to this database | LicenceIncluded | string |
| elastic_pool_max_size_gb | Max data size of the elastic pool in GB | 100 | Number |


# Outputs
| Parameter Name | Description | Type | 
|---|---|---|
| primary_sql_server  | Output of primary SQL server | any |
| secondary_sql_server | Output of secondary SQL server | any |
| sql_db | Output of SQL databses | any |

# Reference
MSSQL documentatin: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_failover_group
Firewall rule: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mariadb_firewall_rule
Extended auditing policy : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database_extended_auditing_policy
Vunlenability assessment rule : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database_vulnerability_assessment_rule_baseline

# Additional details
## Sample usage when using this module in your own modules
```
module "cip-database" {
  source = "../Terraform Modules/AzureSQLDatabase"
  primary_sqlserver_name          = "cip-database-svr-${local.env}"
  admin_username               = "missadministrator"
  admin_password               = "thisIsKat11"
  resource_group_name = azurerm_resource_group.network.name
  location            = local.location
  db_names = ["cip-database-${local.env}"]
  sqlserver_version            = "12.0"
  minimum_tls_version          = "1.2"
  tags = local.tags
  db_tags = local.tags
}
```
## Sample usage with additional parameters and provisioning elastic pool.
module "AzureSQL" {
  source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//AzureSQLDatabase"
  primary_sqlserver_name          = "avatestserver2099"
  secondary_sqlserver_name        = "secondaryserver2099" 
  //admin_username               = "missadministrator"
  //admin_password               = "thisIsKat11"
  resource_group_name          = azurerm_resource_group.avatest.name
  location                     = "Australia East"
  secondary_sqlserver_location = "Australia East"
  sqlserver_version            = "12.0"
  minimum_tls_version          = "1.2"
  tags = {
    environment = "sandbox"
  }
  secondary_sqlserver_tags = {
    environment = "sandbox"
  }
  sqlid_type = "UserAssigned" 
  db_names    = ["mytestsqldb1", "mytestsqldb2"]
  db_tags    = {
    environment = "sandbox"
  }
    long_term_retention_policy = {
    weekly_retention   = "P1W"
    monthly_retention  = "P1M"
    yearly_retention   = "P1Y"
    week_of_year       = 1
  }
short_term_retention_policy = {
  backup_interval_in_hours = 12
  retention_days = 1
}
threat_detection_policy = {
  disabled_alerts = ["Sql_Injection"]
  email_account_admins = "Enabled"
  email_addresses = ["msantosh.ft@gmail.com"]
  retention_days = 1
  state = "Enabled"
  storage_account_access_key = "Disabled"
  storage_endpoint = "Disabled"
  dns_alias_name = ["santoshsqltest3", "santoshsqltest4"]
}
  password_akv_id = module.akv.akv_out.id
  password_akv_access_policy = module.akv.akvap_out.id
  elastic_pool_name = "avaelasticpool"
  elastic_pool_sku = {
    capacity = 100
    //family = "Gen4"
    name = "StandardPool"
    tier = "Standard"
  }
  per_database_settings = {
    max_capacity = 10
    min_capacity = 0
  }
}

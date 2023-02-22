# Introduction 
Provisioning a storage account
Forces storage account to only use https.
Basic code to create a storage account is listed below.
You can create blob containers, fileshares, queues and tables inside the storage account.
You can also set the properties for blobs, queues and fileshares and even routing requirements.
Azure monitor onboarding is optional and all the logs & metrics are also configured for use within this module.
Apart from the required parameters, you can find all the other optional parameters mentioned by the resource provider, that can be configured to meet the needs of the client.
Storage lifecycle management is beyond this module and is not included in this.
The deployment of static website package into storage account is beyond the scope of this module, but the configuration of static website in the storage account is exposed in this module - "static_website"

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.3 | Dec22 | Make ATP resource optional if not enabled | Viktor.Lee |
| 1.2 | Nov22 | Added support private link access | Viktor.Lee |
| 1.1 | Oct22 | Added support for allow_nested_items_to_be_public variable. Commented out some Azure monitor logging as they are not supported | Viktor.Lee |
| 1.0 | July22 | First release | Santosh.Manne |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.3 | 1.3.4 | 3.34.0 |
| 1.2 | 1.3.4 | 3.31.0 |
| 1.1 | 1.3.3 | 3.30.0 |
| 1.0 | 1.1.7 | 3.14.0 |



# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| name | Name of the storage account | string |
| location | Azure region of where to provision the virtual network | string |
| resource_group_name | Name of the virtual network | string |
| tags | Azure Tags | map |

# Optional/Advance Parameters
| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
storage_account_tier | Standard or Premium tier storage account | Standard | String |
storage_account_replication_type | Storage account replication type | LRS | String |
storage_account_kind | Type of storage account | StorageV2 | String |
storage_account_access_tier | Access tier for different types of storage | Hot | String |
cross_tenant_replication_enabled | You can enable cross tenant replication if necessary | False | Boolean |
min_tls_version | Transport security layer version needed | TLS1_2 | String |
shared_access_key_enabled | Enable Shared aceess to storage accounts | True | Boolean |
enable_advanced_threat_protection | Can be used to enable advanced threat protection | False | Boolean |
is_hns_enabled | Can be used to enable heirarchial name space | False | Boolean |
nfs_v3_enabled | Can be used to enable NFSV3 protocol | False | Boolean |
large_file_share_enabled | can be used to enable large file sharing | False | Boolean |
queue_encryption_key_type | Type of encryption | Service | String |
table_encryption_Key_type | Type of encrption | Service | String |
managed_identity_type | Type of managed identity to be assigned | null | String |
managed_identity_ids | List of managed identity ids to be assigned | null | List(string |
blob_soft_delete_retention_days | Specifies the no.of days the blob is retained after deletion | 7 | Number |
container_soft_delete_retention | Specifies the no.of days a container copy is retained after deletion | 7 | Number |
cors_rule | Cross-Origin Resource Sharing parameters | null | object({<br/>allowed_headers = list(string)<br/>  allowed_methods = list(string)<br/>allowed_origins = list(string)<br/>exposed_headers = list(string)<br/>  max_age_in_seconds = number<br/>}) |
lase_access_time_enabled | Used to devise storage lifecycle management policy | False | Boolean |
change_feed_enabled | Change feed for blob service can be enabled | False | Boolean |
default_service_version | API version to be used | null | string |
queue_logging | Type of logs used for queue storage | null | object({<br/>delete = bool<br/>read = bool<br/>    version = string<br/>write = bool<br/>retention_policy_days = number}) |
queue_minute_metrics | Queue metrics to be enabled | null | object({<br/>enabled = bool<br/>version = string<br/>   include_apis = bool<br/>retention_policy_days = number<br/>}) |
queue_hour_metrics | Hourly queue metrics to be enabled | null | object({<br/>enabled = bool<br/>version = string<br/>include_apis = bool<br/>retention_policy_days = number<br/>}) |
share_retention_days | No.of days azurem_storage_share si to be retained | null | Number |
share_smb | SMB block parameters to be configured | null | object({<br/>versions = string<br/>authentication_types = string<br/>kerberos_ticket_encryption_type = string<br/>channel_encryption_type = string<br/>}) |
network_rules | Network rules to restrict access to storage account | null | object({<br/>bypass = list(string)<br/>ip_rules = list(string)<br/>virtual_network_subnet_ids = list(string)<br/>}) |
private_link_access | private_link_access to storage account, must be used together with network_rules | null | list(object({ <br/>endpoint_resource_id = string<br/>endpoint_tenant_id = stirng<br/>})) |
custom_domain | Specify custom domain for storage account | null | object({<br/>name = string<br/>use_subdomain = bool<br/>}) |
customer_managed_key | Specify customer managed key | null | object({<br/>key_vault_key_id = string<br/>    user_assigned_identity_id = string<br/>}) |
routing | Configure routing requirements | null | object({<br/>publish_internet_endpoints = bool<br/>
publish_microsoft_endpoints = bool<br/>choice = string<br/>}) |
active directory | active directory authentication | null | object({<br/>storage_sid = string<br/>domain_name = string<br/>domain_sid  = string<br/>domain_guid = string<br/>forest_name = string<br/>netbios_domain_name = string<br/>}) |
azure_file_authentication | Azure file authentication type | null | String |
containers_list | List the containers to be created | 0 | list(object({<br/>name = string<br/>access_type = string<br/>})) |
file_shares | List the fileshares to be created | 0 | list(object({<br/>name = string<br/>quota = number<br/>})) |
tables | List of tables to be created | 0 | List(string) |
queues | List of storage queues to be created | 0 | List(string) |
logging_retention | Retention period of azure_monitor configuration | 30 | Number |
azure_monitor | Output of Azure monitor module | | |
static_website | Host a static website in Azure blob storage | null | object({<br/>index_document = string <br/> error_404_document = string<br/>}) | 
allow_nested_items_to_be_public | Control whether the storage account nested items are accessible by public | False | Boolean |
    
# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
|sa_out | Output the object of storage account | any |
containers_out | Output of the containers | map | 
file_shares_out | Output of the fileshares created | map |
tables_out | Output of the tables created | map |
queues_out | Output of the queues created | map |

# Reference
Reference for storage accounts: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account#account_tier
Reference for storage account lifecycle management: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_management_policy#version
Reference for hosting a static website in Azure Blob storage: https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website
Tutorial for hosting a static website on Azure Blob storage: https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website-host

# Additional details
## Sample usage when using this module in your own modules
```
module "azure_storageaccount" {
  source              = "./StorageAccount"
  name                = "avasand123456"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags = {
    environment = "sandbox"
  }
  ```
### Sample usage to create containers, fileshares, queues & tables
```
module "azure_storageaccount" {
  source              = "./StorageAccount"
  name                = "avasand123456"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags = {
    environment = "sandbox"
  }
  containers_list = [{name = "democontainer", access_type = "blob"}]
  queues          = ["demoqueue1", "demoqueue2"] 
  file_shares     = [{name = "demoshare", quota = 5}]
  tables          = ["demotable1", "demotable2"]
}
```
### Sample code to include CORS rule, Queue hour metrics, SMB
```
module "azure_storageaccount" {
  source              = "./StorageAccount"
  name                = "avasand123456"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  tags = {
    environment = "sandbox"
  }
  containers_list = [{name = "democontainer", access_type = "blob"}]
  queues          = ["demoqueue1", "demoqueue2"] 
  file_shares     = [{name = "demoshare", quota = 5}]
  tables          = ["demotable1", "demotable2"]
  cors_rule = ({
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    exposed_headers = ["*"]
    max_age_in_seconds = 5
  })
  queue_hour_metrics = ({
    enabled               = true
    version               = 1.0
    include_apis          = true
    retention_policy_days = 5
  })
  smb = ({
    versions = "SMB3.1.1"
    authentication_types = "Kerberos"
    kerberos_ticket_encryption_type = "AES-256"
    channel_encryption_type = "AES-256-GCM"
  })
}

#************************************** Azure Data Factory Vatiables *************************************
variable "data_factory_name" {
  description = " (Required) Specifies the name of the Data Factory. Must be globally unique"
  type        = string
}
variable "location" {
  description = "(Required) Specifies the supported Azure location where the resource exists"
  type        = string 
}
variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Data Factory"
  type        = string
}
variable "tags" {
  description = "(Required) map of tags"
  type        = map
}
variable "managed_virtual_network_enabled" {
  description =  "(Optional) Is Managed Virtual Network enabled?"
  type        = bool
  default     = false
}
variable "public_network_enabled" {
  description = "(Optional) Is the Data Factory visible to the public network?"
  type        = bool
  default     = false
}
variable "customer_managed_key_id" {
  description = "(Optional) Specifies the Azure Key Vault Key ID to be used as the Customer Managed Key (CMK) for double encryption"
  type        = string
  default     = null
}
variable "customer_managed_key_identity_id" {
  description = "(Optional)Specifies the ID of the user assigned identity associated with the Customer Managed Key."
  type        = string
  default     = null
}
variable "github_configuration" {
  description = "(Optional) Github configuration block"
  type = object({
    account_name    = string
    branch_name     = string
    git_url         = string
    repository_name = string
    root_folder     = string
  })
  default    = null
}
variable "global_parameter" {
  description = "(Optional) Global parameters block"
  type        = object({
    name = string
    type = string
    value = string
  })
  default = null
}
variable "managed_identity_type" {
  description = "The type of Managed Identity which should be assigned. Possible values are 'SystemAssigned', 'UserAssigned' and 'SystemAssigned, UserAssigned'"
  type        = string
  default     = null
}
variable "managed_identity_ids" {
  description = "A list of User Managed Identity ID's which should be assigned."
  type        = list(string)
  default     = null
}
variable "vsts_configuration" {
  description = "(Optional) vsts configuration block"
  type        = object({
    account_name    = string
    branch_name     = string
    project_name    = string   
    repository_name = string
    root_folder     = string
    tenant_id       = string
  }) 
  default = null
}
#**************************** Azure Data Factory Managed Endpoint Variables***************************************
variable "private_endpoint_required" {
  description = "(Optional) do you need a private endpoint?"
  type        = string
  default     = false
}
variable "private_endpoint_name" {
  description = "(Optional) Specifies the name which should be used for this Managed Private Endpoint"
  type        = string
  default     = null
}
variable "target_resource_id" {
  description = "(Optional) The ID of the Private Link Enabled Remote Resource which this Data Factory Private Endpoint should be connected to"
  type        = string
  default     = null
}
variable "subresource_name" {
  description = "(Optional) Specifies the sub resource name which the Data Factory Private Endpoint is able to connect to"
  type        = string
  default     = null
}
variable "fqdns" {
  description = "(Optional) Fully qualified domain names"
  type        = list(string)
  default     = null
}
#**************************** Azure Data Factory Pipeline ***********************************************

variable "pipeline_required" {
  description = "(Optional) enable pipeline?"
  type = string
  default = false
}
variable "pipeline_name" {
  description = "(Optional) Specifies the name of the Data Factory Pipeline"
  type = string
  default = null
}
variable "pipeline_description" {
  description = "(Optional) The description for the Data Factory Pipeline"
  type = string
  default = null
}
variable "pipeline_annotations" {
  description = "(Optional) List of tags that can be used for describing the Data Factory Pipeline"
  type = list(string)
  default = null
}
variable "pipeline_concurrency" {
  description = "(Optional) The max number of concurrent runs for the Data Factory Pipeline. Must be between 1 and 50"
  type = number
  default = null
}
variable "pipeline_folder" {
  description = "(Optional) The folder that this Pipeline is in. If not specified, the Pipeline will appear at the root level"
  type = string
  default = null
}
variable "pipeline_moniter_metrics_after_duration" {
  description = "(Optional) The TimeSpan value after which an Azure Monitoring Metric is fired"
  type = number
  default = null
}
variable "pipeline_parameters" {
  description = "(Optional) A map of parameters to associate with the Data Factory Pipeline"
  type = map(string)
  default = null
}
variable "pipeline_activities_json" {
  description = "(Optional) A JSON object that contains the activities that will be associated with the Data Factory Pipeline"
  type = string
  default = null
}
variable "pipeline_variables" {
  description = "(Optional) A map of variables to associate with the Data Factory Pipeline"
  type = map(string)
  default = null
}
#*************************** Azure Monitor Onboarding ***********************************
variable "logging_retention" {
  description = "(Optional) Retention period of azure_monitor configuration"
  default = 30
  type    = number
}
variable "azure_monitor" {
  description = "(Required) Azure Monitor module output to configure monitoring"
  default = null
}
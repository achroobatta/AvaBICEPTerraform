#************************* Azure Policy Definition Variables********************************
variable "policy_name" {
  description = "(Required) Name of the policy definition"
  type        = string
}
variable "policy_type" {
  description = "(Required) The policy type. Possible values are BuiltIn, Custom and NotSpecified"
  type        = string
}
variable "mode" {
  description = " (Required) The policy mode that allows you to specify which resource types will be evaluated"
  type        = string
}
variable "policy_display_name" {
  description = "(Required) The display name of the policy definition"
  type        = string
}
variable "policy_description" {
  description = " (Optional) The description of the policy definition"
  type        = string
  default     = null
}
variable "management_group_id" {
  description = "(Optional) The id of the Management Group where this policy should be defined"
  type        = string
  default     = null
}
variable "policy_rule" {
  description = "(Optional) JSON string representing the rule that contains an if and a then block"
  type        = string
  default     = null
}
variable "policy_metadata" {
  description = "(Optional) JSON string representing additional metadata for policy definition"
  type        = string
  default     = null
}
variable "policy_parameters" {
  description = "(Optional) JSON string that allows you to parameterize your policy definition"
  type        = string
  default     = null
}

#************************* Azure Policy Set Definition (Policicy Initiatives) variables ***********************
variable "policy_set_definition_required" {
  description = "(Optional) enable policy initiative?"
  type = string
  default = false
}
variable "policy_initiative_name" {
  description = "(Optional) The name of the policy set definition"
  type        = string
  default     = null
}
variable "policy_initiative_policy_type" {
  description = "(Optional) The policy set type. Possible values are BuiltIn or Custom"
  type        = string
  default     = null
}
variable "policy_initiative_display_name" {
  description = "(optional) The display name of the policy set definition"
  type        = string
  default     = null
}
variable "policy_initiative_description" {
  description = " (Optional) The description of the policy set definition"
  type        = string
  default     = null
}
variable "policy_initiative_management_group_id" {
  description = "(Optional) The id of the Management Group where this policy set definition should be defined"
  type        = string
  default     = null
}
variable "policy_initiative_metadata" {
  description = "(Optional) JSON object representing additional metadata that should be stored with the policy definition."
  type        = string
  default     = null
}
variable "policy_initiative_parameters" {
  description = "(Optional) JSON string that allows you to parameterize your policy set definition"
  type        = string
  default     = null
}
variable "policy_definition_reference" {
  description = "(Optional) Policy definition reference block"
  type = list(object({
    policy_definition_id = string
    parameter_values     = string
    reference_id         = string
    policy_group_names   = list(string)
  }))
  default = null
}
variable "policy_definition_group" {
  description = "(Optional) policy definition group block"
  type        = list(object({
    name                              = string
    display_name                      = string
    category                          = string
    description                       = string
    additional_metadata_resource_id   = string
  }))
  default     = null
}

#***************************** Management Group Assignment Variables ******************************
variable "management_group_required" {
  description = "(Optional) create a management group?"
  type        = string
  default     = false
}
variable "management_group_name" {
  description = "(Optional) Management group name"
  type        = string
  default     = null
}
variable "mgmtgrp_assignment_required" {
  description = "(Optional) enable management group policy assignmenr?"
  type        = string
  default     = false
}
variable "management_group_policy_assignment_name" {
  description = "(Optional) Management group policy assignment name"
  type        = string
  default     = null
}
variable "description" {
  description = "(Optional) A description which should be used for this Policy Assignment."
  type        = string
  default     = null
}
variable "display_name" {
  description = "(Optional) The Display Name for this Policy Assignment."
  type        = string
  default     = null
}
variable "enforce" {
  description = "(Optional) Specifies if this Policy should be enforced or not?"
  type        = bool
  default     = true
}
variable "location" {
  description = " (Optional) The Azure Region where the Policy Assignment should exist"
  type        = string
  default     = null
}
variable "metadata" {
  description = "(Optional) A JSON mapping of any Metadata for this Policy"
  type        = string
  default     = null 
}
variable "parameters" {
  description = "(Optional) A JSON mapping of any Parameters for this Policy"
  type        = string
  default     = null
}
variable "not_scopes" {
  description = "(Optional) Specifies a list of Resource Scopes (for example a Subscription, or a Resource Group) within this Management Group which are excluded from this Policy."
  type        = list(string)
  default     = []
}
variable "managed_identity_type" {
  description = "(Optional) The Type of Managed Identity which should be added to this Policy Definition. Possible values are SystemAssigned and UserAssigned."
  default     = null
  type        = string
}
variable "managed_identity_ids" {
  description = "(Optional) A list of User Managed Identity IDs which should be assigned to the Policy Definition"
  default     = null
  type        = list(string)
}
variable "non_compliance_message" {
  description = "(Optional) non compliance message block"
  type        = list(object({
    content                         = string
    policy_definition_reference_id  = string
  })) 
  default = []
}
variable "mgmt_policy_exemption_required" {
  description = "(Optional) enable management policy exemption?"
  type        = string
  default     = false
}
variable "exemption_name" {
  description = "(Optional) The name of the Policy Exemption"
  type        = string
  default     = null
}
variable "exemption_category" {
  description = "(Optional) The category of this policy exemption. Possible values are Waiver and Mitigated"
  type        = string  
  default     = null  
}
variable "exemption_desctiption" {
  description = "(Optional) A description to use for this Policy Exemption"
  type        = string
  default     = null
}
variable "exemption_display_name" {
  description = "(Optional) A friendly display name to use for this Policy Exemption"
  type        = string
   default     = null
}
variable "expires_on" {
  description = "(Optional) The expiration date and time in UTC ISO 8601 format of this policy exemption"
  type        = string
  default     = null
} 
variable "policy_definition_reference_ids" {
  description = " (Optional) The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition"
  type        = list(string)
  default     = []    
}
variable "exemption_metadata" {
  description = "(Optional) JSON string representing additional metadata that should be stored with the policy exemption"
  type        = string
  default     = null
}
variable "mgmt_remediation_required" {
  description = "(Optional) enable management group remediation policy?"
  type        = string
  default     = false
}
variable "remediation_name" {
  description = "(Optional) The name of the Policy Remediation"
  type        = string   
  default     = null 
}
variable "policy_definition_id" {
  description = "(Optional) The unique ID for the policy definition within the policy set definition that should be remediated"
  type        = string
  default     = null 
}
variable "location_filters" {
  description = "(Optional) A list of the resource locations that will be remediated."
  type        = list(string)
  default     = null      
}

#*************************** Resource Group Policy Assignment Variables ********************************
variable "rg_policy_assignment_required" {
  description = "(Optional) enable resource group policy assignment?"
  type        = string
  default     = false
}
variable "resource_group_policy_name" {
  description = " (Optional) The name which should be used for the resource group Policy Assignment"
  type        = string
  default     = null
}
variable "resource_group_id" {
  description = "(Optional) The ID of the Resource Group where this Policy Assignment should be created"
  type        = string
  default     = null
}
variable "rg_exemption_required" {
  description = "(Optional) enable resource group exemption policy?"
  type        = string
  default     = false
}
variable "resource_group_policy_exemption_name" {
  description = "(Optional) The name of resource group policy exemption"
  type        = string
  default     = null
}
variable "rg_remediation_required" {
  description = "(Optional) enable resource group remediation policy?"
  type        = string
  default     = false
}
variable "resource_group_policy_remediation_name" {
  description = "(Optional) The name of the Resource Group Policy Remediation"
  type        = string
  default     = null
}
#**************************** Resource Policy Assignment *************************************
variable "resource_assignment_required" {
  description = "(Optional) enable resource policy assignment?"
  type        = string
  default     = false
}
variable "resource_policy_assignment_name" {
  description = "(Optional) The name which should be used for the Resource Policy Assignment"
  type        = string
  default     = null
}
variable "resource_id" {
  description = "(Optional) The ID of the Resource (or Resource Scope) where this should be applied"
  type        = string
  default     = null
}
variable "resource_exemption_required" {
  description = "(Optional) enable resource exemption policy?"
  type        = string
  default     = false
}
variable "resource_exemption_name" {
  description = "(Optional) Name of the resource exemption policy"
  type        = string
  default     = null
}
variable "resource_remediation_required" {
  description = "(Optional) enable resource remediation policy?"
  type        = string
  default     = false
}
variable "resource_remediation_name" {
  description = "(Optional) Name of the resource remediation"
  type        = string
  default     = null
}
#******************************** Subscription Policy Assignment ****************************************
variable "sub_assignment_required" {
  description = "(Optional) enable subscription policy assignment?"
  type        = string
  default     = false
}
variable "subscription_policy_name" {
  description = "(Optional) name of the subscription policy assignment"
  type        = string
  default     = null
}
variable "sub_exemption_required" {
  description = "(Optional) enable subscription exemption policy?"
  type        = string
  default     = false
}
variable "subscription_exemption_name" {
  description = "(Optional) The name of the Subscription Policy Exemption"
  type        = string
  default     = null
}
variable "sub_remediation_required" {
  description = "(Optional) enable subscription remediation policy?"
  type        = string
  default     = false
}
variable "subscription_remediation_name" {
  description = "(Optional) The name of the subscription policy remediation"
  type        = string
  default     = null
}

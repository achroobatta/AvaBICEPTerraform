# Introduction 
This module helps to create a policy definition and policy initiative.
Policy assignment, exemption and remediation at scopes such as management group, resource group, resource and subscription level are also included in this module.
Policy set definition and policy assignment, exemption and remediation at different scopes are made optional in this module. You can turn on these fearutes as required. for example, if you want to turn on the policy set definition resource, you can pass the variable as " policy_set_definition_required = true" in the root module and give the required parameters. Please see the code sample below.
There are many inbuilt policies for use in Azure. If we still want to tailor the policy rules, we can create a custom policy definition and assign it to different scopes.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | Ausgust22 | First release | santosh.manne |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |


# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| Policy_name | Name of the policy definition | string |
| policy_type | policy types | string |
| mode | Policy mode that allows to specify resource type to be evaluated | string |
| policy_display_name | The display name of the policy | string |

# Optional Parameters
| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| policy_description | Policy definition description | null | string |
| management_group_id | Management group id where the policy is to be defined | null | string |
| policy_rule | JSON string representing the rule | null | any |
| policy_metadata | JSON string representing additional metadata | null | any |
| policy_parameters | JSON string that allows you to parameterize | null | any |
| policy_initiative_description | policy set definition description | null | string |
| policy_initiative_management_group_id | management group id | null | string |
| policy_initiative_metadata | JSON object representing additional metadata | null | any |
| policy_initiative_parameters | JSON string to parameterize | null | any |
| policy_definition_reference | one or more policy definition reference blocks | null | list(object({<br/>policy_definition_id = string<br/>parameter_values = any<br/>reference_id = string<br/>policy_group_names = any})) |
| policy_definition_group| one or more policy definition group blocks | null | list(object({<br/>name = string<br/>display_name = string<br/>category = string<br/>description = string<br/>additional_metadata_resource_id = string})) |
| management_group_policy_assignment_description | policy assignment description | null | string |
| management_group_policy_assignment_display_name | display name |null | string |
| management_group_policy_assignment_enforce | enforce policy? | null | boolean |
| management_group_policy_assignment_location | Azure region where this policy should exist | null | string | 
| management_group_policy_assignment_metadata | A JSON mapping of any Metadata | null | any |
| management_group_policy_assignment_parameters | JSON mapping of any Parameters | null |any |
| management_group_policy_assignment_not_scopes | list of Resource Scopes | [] | list["string1", "string2"] |
| managed_identity_ids | User Managed Identity IDs | null | list["string1", "string2"] |
| non_compliance_message | non compliance message | [] | list(object({<br/>content = string<br/>policy_definition_reference_id = string})) | 
| exemption_desctiption | exemption desctiption | null | string |
| exemption_display_name | display name | null | string |
| expires_on | expiration date and time in UTC ISO 8601 format | null | string |
| policy_definition_reference_ids | reference ID list | [] | list["string1", "string2"] |
| exemption_metadata | JSON string representing additional metadata | null | any |
| policy_definition_id | unique ID for the policy definition within the policy set definition that should be remediated | null | string | 
| location_filters | list of the resource locations | null | list["string1", "string2"] |
| policy_initiative_name | Name of the policy set definition | | null | string |
| policy_initiative_policy_type | policy type | null | string |
| policy_initiative_display_name | display name | null | string |
| management_group_name | Management group name | null | string |
| management_group_policy_assignment_name | Name for the management group policy assignment | null | string | 
| exemption_name | Policy exemption name | null | string |
| exemption_category | exemption category | null | string |
| remediation_name | name of the policy remediation | null | string |
| resource_group_policy_name | Name for rg policy assignment | null | string |
| resource_group_id | id of the rg | null |string |
| resource_group_policy_exemption_name | name of the rg exemption policy | null | string |
| resource_group_policy_remediation_name | name of the rg policy remediation | null | string |
| resource_policy_assignment_name | Name of the resource policy assignment | null | string |
| resource_id | id of the resource | null | string |
| resource_exemption_name| name of the resource exemption policy | null | null | string |
| resource_remediation_name | Name of the resource remediation | null | string |
| subscription_policy_name | name of the subscription policy | null | string |
| subscription_exemption_name | name of the subscription exemption policy | null | string |
| subscription_remediation_name | name of the subscriptio remediation | null | string |
| policy_set_definition_required | enable policy set definition? | false | string | 
| management_group_required | create management group? | false | string | 
| mgmtgrp_assignment_required | enable management group policy assignment? | false | string | 
| mgmt_policy_exemption_required | enable management group exemption policy | false | string |
| mgmt_remediation_required | enable management group remediation policy? | false | string |
| rg_policy_assignment_required | enable resource group policy assignment? | false | string | 
| rg_exemption_required | enable resource group exemption policy | false | string |
| rg_remediation_required | enable resource group remediation policy? | false | string |
| resource_assignment_required | enable resource policy assignment? | false | string | 
| resource_exemption_required | enable resource exemption policy | false | string |
| resource_remediation_required | enable resource remediation policy? | false | string |
| sub_assignment_required | enable subscription policy assignment? | false | string | 
| sub_exemption_required | enable subscription exemption policy | false | string |
| sub_remediation_required | enable subscription remediation policy? | false | string |


# Outputs
| Parameter Name | Description | Type | 
|---|---|---|
| policy_definition_id| Output ID of policy definition | any | 
| id | output ID of policy set definition | any |
| management_group_id | Output Id of management group policy | any | 
| mgmt_assignment_id | Output ID of the management assignment | any |
| exemption_policy_id | Output ID of the management exemption policy | any |
| policy_remediation_id | Output ID of the managment remediation policy | any |
| resource_group_policy_id | Output Id of resource group policy | any | 
| rg_exemption_policy_id | Output ID of the resource group exemption policy | any |
| rg_remediation_id | Output ID of the resource group remediation policy | any |
| resource_policy_id | Output Id of resource policy | any | 
| resource_exemption_id | Output ID of the resource  exemption policy | any |
| resource_remediation_id | Output ID of the resource remediation policy | any |
| subscription_policy_id | Output Id of subscription policy | any | 
| subscription_exemption_id | Output ID of the subscription  exemption policy | any |
| subscription_remediation_id | Output ID of the subscription remediation policy | any |

# Reference
Azure Policy Overview: https://docs.microsoft.com/en-us/azure/governance/policy/overview 
Azure Policy Initiative Definition: https://docs.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure
Azure policy definition: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition

# Additional details
## Sample usage when using this module in your own modules
```
module "policy" {
  source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules/AzurePolicy"
  policy_name    = "specified Locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations policy definition"
  
 policy_initiative_parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS
  
policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "equals": "Australia East"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
  policy_set_definition_required = true
  policy_initiative_name = "DemoPolicyInitiative"
  policy_initiative_policy_type = "Custom"
  policy_initiative_display_name = "DEMO POLICY INITIATIVE"
 policy_definition_reference = [
  {
    reference_id          = null
    policy_group_names   = null
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e765b5de-1225-4ba3-bd56-1ac6695af988"
    parameter_values     = <<VALUE
    {
      "listOfAllowedLocations": {"value": "[parameters('allowedLocations')]"}
    }
    VALUE
  }
  ]
  policy_definition_group = [
    {
      name = "location restriction"
      display_name = "RESTRICTION FOR RESOURCE LOCATION"
      category = "General"
      description = null
      metadata    = null
      additional_metadata_resource_id = null

    }
  ]
}
```
## Sample usage for resource group policy assignment, exemption and remediation
```
resource "azurerm_resource_group" "avatest" {
  name     = "avatest"
  location = "Australia East"
}
resource "azurerm_virtual_network" "avanet" {
  name                = "avanet"
  resource_group_name = azurerm_resource_group.avatest.name
  location            = "Australia East"
  address_space       = ["10.0.0.0/16"]
}*/
module "policy" {
  source = "https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules/AzurePolicy"
  policy_name         = "specified Locations"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Allowed Locations policy definition"
  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "equals": "Australia East"
      }
    },
    "then": {
      "effect": "Deny"
    }
  }
POLICY_RULE
resource_group_policy_name = "demorgpolicy"
resource_group_id = azurerm_resource_group.avatest.id
resource_group_policy_exemption_name = "demorgexempt"
resource_group_policy_remediation_name = "rgremediate"
exemption_category = "Mitigated"

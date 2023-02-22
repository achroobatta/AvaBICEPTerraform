#Manages a policy rule definition(business rules) on a management group or your provider subscription.
resource "azurerm_policy_definition" "policy" {
  name                = var.policy_name
  policy_type         = var.policy_type
  mode                = var.mode
  display_name        = var.policy_display_name
  description         = var.policy_description
  management_group_id = var.management_group_id
  policy_rule         = var.policy_rule
  metadata            = var.policy_metadata
  parameters          = var.policy_parameters 
}

#Policy set definitions,also known as policy initiatives is several business rules grouped together.
resource "azurerm_policy_set_definition" "example" {
  count = var.policy_set_definition_required ? 1 : 0 
  name                = var.policy_initiative_name
  policy_type         = var.policy_initiative_policy_type
  display_name        = var.policy_initiative_display_name
  description         = var.policy_initiative_description
  management_group_id = var.policy_initiative_management_group_id
  metadata            = var.policy_initiative_metadata
  parameters          = var.policy_initiative_parameters
  dynamic "policy_definition_reference" {
    for_each = var.policy_definition_reference != null ? var.policy_definition_reference : []
    content {
      policy_definition_id  = policy_definition_reference.value.policy_definition_id
      parameter_values      = policy_definition_reference.value.parameter_values
      reference_id          = policy_definition_reference.value.reference_id
      policy_group_names    = policy_definition_reference.value.policy_group_names
    }
  }
  dynamic "policy_definition_group" {
    for_each = var.policy_definition_group != null ? var.policy_definition_group : []
    content {
      name                            = policy_definition_group.value.name
      display_name                    = policy_definition_group.value.display_name
      category                        = policy_definition_group.value.category
      description                     = policy_definition_group.value.description
      additional_metadata_resource_id = policy_definition_group.value.additional_metadata_resource_id
    }
  }
}

#***************************** Management Group Policy assignment ***************************************
#Manages a Policy Assignment to a Management Group.
resource "azurerm_management_group" "MgmtGrp" {
  count = var.management_group_required  ? 1 : 0
  display_name = var.management_group_name
}
resource "azurerm_management_group_policy_assignment" "Mgmtpolicy" {
  count = var.mgmtgrp_assignment_required ? 1 : 0
  name                 = var.management_group_policy_assignment_name
  policy_definition_id = azurerm_policy_definition.policy.id
  management_group_id  = azurerm_management_group.MgmtGrp[count.index].id
  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  location             = var.location
  metadata             = var.metadata
  parameters           = var.parameters
  not_scopes           = var.not_scopes
  dynamic "identity" {
    for_each = var.managed_identity_type != null ? ["true"] : []
    content {
      type          = var.managed_identity_type
      identity_ids  = var.managed_identity_type == "UserAssigned" ? var.managed_identity_ids : null
    }
  }
  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message != null ? var.non_compliance_message : []
    content {
      content                         = non_compliance_message.value.content
      policy_definition_reference_id  =  non_compliance_message.value.policy_definition_reference_id
    }
  }
}
#Manages a Management Group Policy Exemption
resource "azurerm_management_group_policy_exemption" "example" {
  count = var.mgmt_policy_exemption_required ? 1: 0
  name                 = var.exemption_name
  management_group_id  = azurerm_management_group.MgmtGrp[count.index].id
  policy_assignment_id = azurerm_management_group_policy_assignment.Mgmtpolicy[count.index].id
  exemption_category   = var.exemption_category
  description          = var.exemption_desctiption
  display_name         = var.exemption_display_name
  expires_on           = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata             = var.exemption_metadata  
}
#Manages an Azure Management Group Policy Remediation
resource "azurerm_management_group_policy_remediation" "remediation" {
  count = var.mgmt_remediation_required ? 1 : 0
  name                  = var.remediation_name
  management_group_id   = azurerm_management_group.MgmtGrp[count.index].id
  policy_assignment_id  = azurerm_management_group_policy_assignment.Mgmtpolicy[count.index].id
  policy_definition_id  = var.policy_definition_id
  location_filters      = var.location_filters
}
#*************************** Resource Group Policy Assignment ********************************
#Manages a Resource Group Policy Assignment
resource "azurerm_resource_group_policy_assignment" "rg" {
  count = var.rg_policy_assignment_required ? 1 : 0
  name                 = var.resource_group_policy_name
  resource_group_id    = var.resource_group_id
  policy_definition_id = azurerm_policy_definition.policy.id
  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  location             = var.location
  metadata             = var.metadata
  parameters           = var.parameters
  not_scopes           = var.not_scopes
  dynamic "identity" {
    for_each = var.managed_identity_type != null ? ["true"] : []
    content {
      type          = var.managed_identity_type
      identity_ids  = var.managed_identity_type == "UserAssigned" ? var.managed_identity_ids : null
    }
  }
  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message != null ? var.non_compliance_message : []
    content {
      content                         = non_compliance_message.value.content
      policy_definition_reference_id  =  non_compliance_message.value.policy_definition_reference_id
    }
  }
}

#Manages a Resource Group Policy Exemption
resource "azurerm_resource_group_policy_exemption" "rg_exemption" {
  count = var.rg_exemption_required ? 1 : 0
  name                 = var.resource_group_policy_exemption_name
  resource_group_id    = var.resource_group_id
  policy_assignment_id = azurerm_resource_group_policy_assignment.rg[count.index].id
  exemption_category   = var.exemption_category
  description          = var.exemption_desctiption
  display_name         = var.exemption_display_name
  expires_on           = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata             = var.exemption_metadata  
}
#Manages an Azure Resource Group Policy Remediation
resource "azurerm_resource_group_policy_remediation" "rg_remediation" {
  count = var.rg_remediation_required ? 1 : 0
  name                 = var.resource_group_policy_remediation_name
  resource_group_id    = var.resource_group_id
  policy_assignment_id = azurerm_resource_group_policy_assignment.rg[count.index].id
  location_filters      = var.location_filters
}

#**************************** Resource Policy Assignment *************************************
#Manages a Policy Assignment to a Resource
resource "azurerm_resource_policy_assignment" "resource" {
  count = var.resource_assignment_required ? 1 : 0
  name                 = var.resource_policy_assignment_name
  resource_id          = var.resource_id
  policy_definition_id = azurerm_policy_definition.policy.id
  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  location             = var.location
  metadata             = var.metadata
  parameters           = var.parameters
  not_scopes           = var.not_scopes
  dynamic "identity" {
    for_each = var.managed_identity_type != null ? ["true"] : []
    content {
      type          = var.managed_identity_type
      identity_ids  = var.managed_identity_type == "UserAssigned" ? var.managed_identity_ids : null
    }
  }
  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message != null ? var.non_compliance_message : []
    content {
      content                         = non_compliance_message.value.content
      policy_definition_reference_id  =  non_compliance_message.value.policy_definition_reference_id
    }
  }
}

#Manages a Resource Policy Exemption
resource "azurerm_resource_policy_exemption" "resource_exemption" {
  count = var.resource_exemption_required ? 1 : 0
  name                 = var.resource_exemption_name
  resource_id          = var.resource_id
  policy_assignment_id = azurerm_resource_policy_assignment.resource[count.index].id
  exemption_category   = var.exemption_category
  description          = var.exemption_desctiption
  display_name         = var.exemption_display_name
  expires_on           = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata             = var.exemption_metadata  
}

#Manages an Azure Resource Policy Remediation
resource "azurerm_resource_policy_remediation" "resource_remediation" {
  count = var.resource_remediation_required ? 1 : 0
  name                    = var.resource_remediation_name
  resource_id             = var.resource_id
  policy_assignment_id    = azurerm_resource_policy_assignment.resource[count.index].id
  policy_definition_id    = var.policy_definition_id
  location_filters        = var.location_filters
}

#******************************** Subscription Policy Assignment ****************************************
data "azurerm_subscription" "current" {}
#Manages a Subscription Policy Assignment
resource "azurerm_subscription_policy_assignment" "sub" {
  count = var.sub_assignment_required ? 1 : 0
  name                 = var.subscription_policy_name
  policy_definition_id = azurerm_policy_definition.policy.id
  subscription_id      = data.azurerm_subscription.current.id
  description          = var.description
  display_name         = var.display_name
  enforce              = var.enforce
  location             = var.location
  metadata             = var.metadata
  parameters           = var.parameters
  not_scopes           = var.not_scopes
  dynamic "identity" {
    for_each = var.managed_identity_type != null ? ["true"] : []
    content {
      type          = var.managed_identity_type
      identity_ids  = var.managed_identity_type == "UserAssigned" ? var.managed_identity_ids : null
    }
  }
  dynamic "non_compliance_message" {
    for_each = var.non_compliance_message != null ? var.non_compliance_message : []
    content {
      content                         = non_compliance_message.value.content
      policy_definition_reference_id  =  non_compliance_message.value.policy_definition_reference_id
    }
  }
}

#Manages a Subscription Policy Exemption
resource "azurerm_subscription_policy_exemption" "sub_exemption" {
  count = var.sub_exemption_required ? 1 : 0
  name                 = var.subscription_exemption_name
  subscription_id      = data.azurerm_subscription.current.id
  policy_assignment_id = azurerm_subscription_policy_assignment.sub[count.index].id
  exemption_category   = var.exemption_category
  description          = var.exemption_desctiption
  display_name         = var.exemption_display_name
  expires_on           = var.expires_on
  policy_definition_reference_ids = var.policy_definition_reference_ids
  metadata             = var.exemption_metadata  
}
#Manages an Azure Subscription Policy Remediation
resource "azurerm_subscription_policy_remediation" "sub_remediation" {
  count = var.sub_remediation_required ? 1 : 0
  name                 = var.subscription_remediation_name
  subscription_id      = data.azurerm_subscription.current.id
  policy_assignment_id = azurerm_subscription_policy_assignment.sub[count.index].id
  policy_definition_id = var.policy_definition_id
  location_filters      = var.location_filters
}




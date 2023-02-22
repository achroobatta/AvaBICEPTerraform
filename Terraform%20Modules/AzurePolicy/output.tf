output "policy_definition_id" {
  value = "azurerm_policy_definition.policy.id"
}
output "id" {
  value = "azurerm_policy_set_definition.example.id"
}
output "management_group_id" {
  value = "azurerm_management_group.MgmtGrp.id"
}
output "mgmt_assignment_id" {
  value = "azurerm_management_group_policy_assignment.Mgmtpolicy.id"
}
output "exemption_policy_id" {
  value = "azurerm_management_group_policy_exemption.example.id"
}
output "policy_remediation_id" {
  value = "azurerm_management_group_policy_remediation.remediation.id"
}
output "resource_group_policy_id" {
  value = "azurerm_resource_group_policy_assignment.rg"
}
output "rg_exemption_policy_id" {
  value = "azurerm_resource_group_policy_exemption.rg_exemption.id"
}
output "rg_remediation_id" {
  value = "azurerm_resource_group_policy_remediation.rg_remediation.id"
}
output "resource_policy_id" {
  value = "azurerm_resource_policy_assignment.resource.id"
}
output "resource_exemption_id" {
  value = "azurerm_resource_policy_exemption.resource_exemption.id"
}
output "resource_remediation_id" {
  value = "azurerm_resource_policy_remediation.resource_remediation.id"
}
output "subscription_policy_out" {
  value = "azurerm_subscription_policy_assignment.sub.id"
}
output "subscription_exemption_id" {
  value = "azurerm_subscription_policy_exemption.sub_exemption.id"
}
output "subscription_remediation_id" {
  value = "azurerm_subscription_policy_remediation.sub_remediation.id"
}


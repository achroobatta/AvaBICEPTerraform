# Introduction 
This template will deploy Policies with the `targetScope` as `managementGrop`. 

Azure Policy helps to enforce organizational standards and to assess compliance at-scale. Through its compliance dashboard, it provides an aggregated view to evaluate the overall state of the environment, with the ability to drill down to the per-resource, per-policy granularity. It also helps to bring your resources to compliance through bulk remediation for existing resources and automatic remediation for new resources.

Common use cases for Azure Policy include implementing governance for resource consistency, regulatory compliance, security, cost, and management. Policy definitions for these common use cases are already available in your Azure environment as built-ins to help you get started

<i>The policy assignment name length must not exceed '24' characters</i>

More details about Azure Policies can be referred [here](https://docs.microsoft.com/en-us/azure/governance/policy/overview)


## Version
| Version | Date | Release Notes | Author
|---|---|---|---|
| 1.0.0 | Aug22 | First release | Rama Balla


## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0.0 | |


## Module Dependencies
| Module Name | Description | Tested Version | 
|---|---|---|
| [PolicyDefinitions](https://docs.microsoft.com/en-us/azure/governance/policy/samples/built-in-policies) | Before applying or assigning a Policy, It must be defined first as we refer the PolicyDefinitionId as part of the PolicyAssignment. Azure provides built-in policy definitions as well. Refer to `policyDefinitions` module under this repo for more details||

### Assign a policy using Azure cli, Azure Powershell commands or Azure Portal 
- [Azure Cli](https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-azurecli)
- [Azure PowerShell](https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-powershell)
- [Azure portal](https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-portal)


## Required Parameters
| Parameter Name | Description |  Type | 
|---|---|---|
|policyAssignmentObject | The object that contains several policyAssignments | Object |
|location | Location where the resources get deployed | string
|targetScope |Applicate Scope Level | string
|policyName | Name of the policy assignment such as `CIS, ISO27001 etc` | string

## Optional/Advance Parameters
- There are no advance or optional Parameters.

## Outputs
- There are no outputs.


## Additional details
- None


## References
- [Assign Policy through Azure Cli](https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-azurecli)
- [Assign Policy through Azure PowerShell](https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-powershell)
- [Assign Policy through Azure portal](https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-portal)
- [Assign Policy through Bicep](https://docs.microsoft.com/en-us/azure/governance/policy/assign-policy-bicep?tabs=azure-powershell)


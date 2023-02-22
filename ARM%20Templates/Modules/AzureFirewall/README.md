# Introduction 
This template deploys an Azure Firewall with Firewall Policy (including multiple application and network rules) referencing IP Groups in application and network rules.

IP Groups is a top-level resource that allows you to group and manage IP addresses in Firewall Policy rules. You can give your IP Group a name and create one by entering IP addresses or uploading a file. It eases your management experience and reduce time spent managing IP addresses by using them in a single firewall policy or across multiple firewall policies.

An IP Group can support individual or multiple IP addresses, ranges, or subnets.

- <img src="../../img/azurefirewall_all_resources.png" withd=300>

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | su.myat.khine.win |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
|vNetCopyIndex|Virtual network that deploys vNet with multiple subnets options.||

### Create resources using Azure cli and Azure Powershell commands 

## Required Parameters


| Parameter Name | Description |  Type | 
|---|---|---|
|azureFirewallName|Name of the firewall|string|
|applicationRuleCollections|Application Rule array collections|array|
|networkRuleCollections|Network Rule array collections|array|
|virtualNetworkName|Name of the virtual network|string|

- **NOTE:** 
    - For applicationRuleCollections and networkRuleCollections, the details are passed via the parameters file.
    - For natRuleCollections, it is passed within the template because the destinated publicIPAddress are required. From the parameter file, this destinated publicIPAddress cannot be accessed. 


## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

## Additional details
### Sample usage when using this module in your own modules

```

```

## References
- [Create a Firewall and FirewallPolicy with Rules and Ipgroups](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.network/azurefirewall-create-with-firewallpolicy-apprule-netrule-ipgroups)
- [Quickstart: Create an Azure Firewall and a firewall policy - ARM template](https://docs.microsoft.com/en-us/azure/firewall-manager/quick-firewall-policy)
- [Deploy and configure Azure Firewall using the Azure portal](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal)
- [Azure Firewall Policy rule sets](https://docs.microsoft.com/en-us/azure/firewall/policy-rule-sets)
- [Microsoft.Network firewallPolicies/ruleCollectionGroups](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/firewallpolicies/rulecollectiongroups?pivots=deployment-language-arm-template)
-[azurefirewall-create-with-firewallpolicy-apprule-netrule-ipgroups](https://github.com/jlopezpa/azure-quickstart-templates/blob/393ae00facd461805bd7595f0cc28f7f99c11b16/quickstarts/microsoft.network/azurefirewall-create-with-firewallpolicy-apprule-netrule-ipgroups/azuredeploy.json)



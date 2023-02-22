# Introduction 
This template deploys an Azure Firewall with Firewall Policy and firewall policy rule collection group.

- [Azure Firewall is a cloud-native and intelligent network firewall security service that provides the best of breed threat protection for your cloud workloads running in Azure. It's a fully stateful, firewall as a service with built-in high availability and unrestricted cloud scalability. It provides both east-west and north-south traffic inspection.](https://docs.microsoft.com/en-us/azure/firewall/overview)
- [East-west traffic](https://en.wikipedia.org/wiki/East-west_traffic) - a network traffic within a specific data center or a local area network (LAN)
- [North-south traffic](https://en.wikipedia.org/wiki/North-south_traffic) - client to server traffic, between the data center and the rest of the network (anything outside the data center).
- The terms have come into use from the way network diagrams are typically drawn, with servers or access switches spread out horizontally, and external connections at the top or bottom.
    - ![East west north south traffic](https://socradar.io/wp-content/uploads/2020/09/my-visual_48541384.png)
## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | August22 | First release | su.myat.khine.win |


## Module Dependencies
- The following existing resources will be used for the firewall template deployment.

| Module Name | Description | Tested Version | 
|---|---|---|
|subnet|||
|loganlytics|||
|publicIpAddress|||

### Create resources using Azure cli and Azure Powershell commands 

## Required Parameters


| Parameter Name | Description |  Type | 
|---|---|---|
|fwObject|Firewall Object consists of name, environment, skuName, skuTier, pip.|object|
|workspaceName|Params from the global.yml|string|
|workspaceGroup|Params from the global.yml|string|
|hubSubscription|Params from the global.yml|string|
|networkGroup|Params from the global.yml|string|
|fwPrefix|Params from the global.yml|string|
|fwpPrefix|Params from the global.yml|string|
|vnPrefix|Params from the global.yml|string|
|pipPrefix|Params from the global.yml|string|
|location|Params from the global.yml|string|

## Optional/Advance Parameters

There are no advance or optional Parameters.

## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

## Additional details
### Sample usage when using this module in your own modules



## References
- [Deploy and configure Azure Firewall using the Azure portal](https://docs.microsoft.com/en-us/azure/firewall/tutorial-firewall-deploy-portal)
- [Azure Firewall Policy rule sets](https://docs.microsoft.com/en-us/azure/firewall/policy-rule-sets)
- [Microsoft.Network firewallPolicies/ruleCollectionGroups](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/firewallpolicies/rulecollectiongroups?pivots=deployment-language-arm-template)
-[azurefirewall-create-with-firewallpolicy-apprule-netrule-ipgroups](https://github.com/jlopezpa/azure-quickstart-templates/blob/393ae00facd461805bd7595f0cc28f7f99c11b16/quickstarts/microsoft.network/azurefirewall-create-with-firewallpolicy-apprule-netrule-ipgroups/azuredeploy.json)



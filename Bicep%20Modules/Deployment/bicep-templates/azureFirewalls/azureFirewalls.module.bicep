@description('Azure Firewall')
param fwObject object
param tags object

// Params from the global.yml VGS
param workspaceName string
param workspaceGroup string
param hubSubscription string
param networkGroup string
param fwPrefix string
param fwpPrefix string
param vnPrefix string
param pipPrefix string
param location string

// Existing resources required
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${vnPrefix}${fwObject.name}/AzureFirewallSubnet'
  scope: resourceGroup(networkGroup)
}
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
//In the same resource group as the firewall
resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = {
  name: '${pipPrefix}${fwObject.pip}'
  scope: resourceGroup(networkGroup)
}

//Create resources
resource firewallPolicy 'Microsoft.Network/firewallPolicies@2021-05-01' = {
  name: '${fwpPrefix}${fwObject.name}'
  location: location
  tags: tags
  properties: {
    insights: {
      isEnabled: true
      logAnalyticsResources: {
        defaultWorkspaceId: {
          id: logAnalytics.id
        }
      }
      retentionDays: 90
    }
    threatIntelWhitelist: {
      fqdns: []
      ipAddresses: []
    }
    sku: {
      tier: fwObject.skuTier
    }
    threatIntelMode: 'Alert'
  }
}

resource firewallPolicyRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2020-11-01' = {
  parent: firewallPolicy
  name: 'DefaultNetworkRuleCollectionGroup'
  properties: {
    priority: 1000
    ruleCollections: [
      {
        name: 'AllowAll'
        priority: 1000
        action: {
          type: 'Allow'
        }
        rules: [
          {
            name: 'Allow_all'
            ipProtocols: [
              'Any'
            ]
            destinationPorts: [
              '*'
            ]
            sourceAddresses: [
              '*'
            ]
            sourceIpGroups: []
            ruleType: 'NetworkRule'
            destinationIpGroups: []
            destinationAddresses: [
              '*'
            ]
            destinationFqdns: []
          }
        ]
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
      }
    ]
  }
}

resource azureFirewall 'Microsoft.Network/azureFirewalls@2021-05-01' = {
  name: '${fwPrefix}${fwObject.name}'
  location: location
  tags: tags
  properties: {
    additionalProperties: {}
    firewallPolicy: {
      id: firewallPolicy.id
    }
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          publicIPAddress: {
            id: publicIpAddress.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
    sku: {
      name: fwObject.skuName
      tier: fwObject.skuTier
    }
  }
}

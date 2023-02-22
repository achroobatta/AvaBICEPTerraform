targetScope = 'managementGroup'
// Params from the *.parameters.json file
//TODO Fix this passing of redundant object
param policyDefinitionObject object

resource locationPolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Avanoso - Allow Only AustraliaEast and AustraliaEast Resources'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    parameters: {}
    policyRule: {
      if: {
        not: {
          field: 'location'
          in: [
            'AustraliaEast'
            'AustraliaSouthEast'
            'Global'
            null
          ]
        }
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource pipPolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Avanoso - Network interfaces should not have public IPs'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    parameters: {}
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'Microsoft.Network/networkInterfaces'
          }
          {
            not: {
              field: 'Microsoft.Network/networkInterfaces/ipconfigurations[*].publicIpAddress.id'
              notLike: '*'
            }
          }
        ]
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

resource whitelistedResourcesPolicy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'Avanoso - Allowed resource types'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    parameters: {}
    policyRule: {
      if: {
        not: {
          field: 'type'
          in: [
            'Microsoft.Advisor/configurations'
            'Microsoft.Authorization/classicAdministrators'
            'Microsoft.Authorization/locks'
            'Microsoft.Authorization/policyAssignments'
            'Microsoft.Authorization/policyDefinitions'
            'Microsoft.Authorization/policySetDefinitions'
            'Microsoft.Authorization/roleAssignments'
            'Microsoft.Authorization/roleDefinitions'
            'Microsoft.Compute/availabilitySets'
            'Microsoft.Compute/disks'
            'Microsoft.Compute/galleries'
            'Microsoft.Compute/galleries/images'
            'Microsoft.Compute/galleries/images/versions'
            'Microsoft.compute/sshpublickeys'
            'Microsoft.Compute/virtualMachines'
            'Microsoft.Compute/virtualMachines/extensions'
            'Microsoft.DevTestLab/schedules'
            'Microsoft.Insights/actionGroups'
            'Microsoft.Insights/activityLogAlerts'
            'Microsoft.Insights/dataCollectionEndpoint'
            'Microsoft.Insights/components'
            'Microsoft.Insights/dataCollectionRules'
            'Microsoft.Insights/dataCollectionRuleAssociations'
            'Microsoft.Insights/diagnosticSettings' 
            'Microsoft.Insights/metricAlerts'
            'Microsoft.Insights/scheduledQueryRules'  
            'Microsoft.Insights/workbooks'                        
            'Microsoft.KeyVault/vaults'
            'Microsoft.KeyVault/vaults/accessPolicies'
            'Microsoft.KeyVault/vaults/keys'
            'Microsoft.KeyVault/vaults/privateEndpointConnections'
            'Microsoft.KeyVault/vaults/secrets'
            'Microsoft.Managedidentity/userAssignedIdentities'
            'Microsoft.Network/applicationSecurityGroups'
            'Microsoft.Network/azureFirewalls'
            'Microsoft.Network/firewallPolicies'
            'Microsoft.Network/firewallPolicies/ruleGroups'
            'Microsoft.Network/firewallPolicies/ruleCollectionGroups'
            'Microsoft.Network/bastionHosts'
            'Microsoft.Network/localNetworkGateways'
            'Microsoft.Network/networkInterfaces'
            'Microsoft.Network/networkSecurityGroups'
            'Microsoft.Network/networkSecurityGroups/securityRules'
            'Microsoft.Network/networkWatchers'
            'Microsoft.Network/networkWatchers/connectionMonitors'
            'Microsoft.Network/networkWatchers/connectivityCheck'
            'Microsoft.Network/networkWatchers/connectionMonitors'
            'Microsoft.Network/networkWatchers/connectionMonitors/providers/Microsoft.Insights/metricDefinitions'
            'Microsoft.Network/networkWatchers/flowLogs'
            'Microsoft.Network/networkWatchers/lenses'
            'Microsoft.Network/networkWatchers/packetCaptures'
            'Microsoft.Network/networkWatchers/pingMeshes'
            'Microsoft.Network/networkWatchers/topology'
            'Microsoft.Network/publicIPAddresses'
            'Microsoft.Network/privateEndpoints'
            'Microsoft.Network/privateEndpoints/privateLinkServiceProxies'
            'Microsoft.Network/routeTables'
            'Microsoft.Network/virtualNetworks'
            'Microsoft.Network/routeTables'
            'Microsoft.Network/routeTables/routes'
            'Microsoft.Network/virtualNetworks/subnets'
            'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
            'Microsoft.Network/virtualNetworks/remoteVirtualNetworkPeeringProxies'
            'Microsoft.Network/virtualNetworkGateways'
            'Microsoft.Operationalinsights/querypacks'
            'Microsoft.OperationalInsights/workspaces'
            'Microsoft.OperationalInsights/workspaces/dataExports'
            'Microsoft.OperationalInsights/workspaces/linkedServices'
            'Microsoft.OperationalInsights/workspaces/linkedStorageAccounts'
            'Microsoft.OperationalInsights/workspaces/dataSources'
            'Microsoft.OperationalInsights/workspaces/savedSearches'
            'Microsoft.OperationalInsights/workspaces/storageInsightConfigs'
            'Microsoft.OperationalInsights/workspaces/tables'
            'Microsoft.OperationsManagement/solutions'
            'Microsoft.Resources/resourceGroups'
            'Microsoft.Resources/deployments'
            'Microsoft.Resources/subscriptions'
            'Microsoft.Resources/subscriptions/resourceGroups'
            'Microsoft.Security/assessmentMetadata'
            'Microsoft.Security/autoProvisioningSettings'
            'Microsoft.Security/policies'
            'Microsoft.Security/pricings'
            'Microsoft.Security/securityContacts'
            'Microsoft.Security/settings'
            'Microsoft.Security/locations/westcentralus/jitNetworkAccessPolicies'
            'Microsoft.Storage/storageAccounts/privateEndpointConnections'
            'Microsoft.Storage/storageAccounts'
            'Microsoft.Storage/storageAccounts/blobServices'
            'Microsoft.Storage/storageAccounts/blobServices/containers'
            'Microsoft.Storage/storageAccounts/fileServices'
            'Microsoft.Storage/storageAccounts/fileServices/shares'
            'Microsoft.Storage/storageAccounts/queueServices'
            'Microsoft.Storage/storageAccounts/queueServices/queues'
            'Microsoft.Storage/storageAccounts/tableServices'
            'Microsoft.Storage/storageAccounts/tableServices/tables'
            'Microsoft.Support/supportTickets'
            'Microsoft.Visualstudio/account'
          ]
        }
      }
      then: {
        effect: 'deny'
      }
    }
  }
}

@description('Virtual network object')
param vnetObject object
param location string
param name string
param tags object
param snPrefix string
param nsgPrefix string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string

// Existing resources required
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: name
  tags: tags
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: vnetObject.addressPrefixes
    }
    dhcpOptions: empty(vnetObject.dnsServers) ? null : {
      dnsServers: vnetObject.dnsServers
    }
    subnets: [for subnet in vnetObject.subnets: {
      name: subnet.builtin ? subnet.name : '${snPrefix}${subnet.name}' //If Azure specified subnet name 
      properties: {
        addressPrefix: subnet.addressPrefix
        delegations: contains(subnet, 'delegation') ? [ //fix this later
          {
            name: '${subnet.name}-delegation'
            properties: {
              serviceName: subnet.delegation
            }
          }
        ] : []
        natGateway: contains(subnet, 'natGatewayId') ? {
          id: subnet.natGatewayId
        } : null
        networkSecurityGroup: contains(subnet, 'nsgName') ? {
          id: resourceId('Microsoft.Network/networkSecurityGroups','${nsgPrefix}${subnet.nsgName}')
        } : null
        routeTable: contains(subnet, 'udrId') ? {
          id: subnet.udrId
        } : null
        privateEndpointNetworkPolicies: subnet.privateEndpointNetworkPolicies
        privateLinkServiceNetworkPolicies: subnet.privateLinkServiceNetworkPolicies
        serviceEndpoints: contains(subnet, 'serviceEndpoints') ? subnet.serviceEndpoints : null
      }
    }]
  }
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: vnet
  name: name
  properties: {
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          days: 60
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    storageAccountId: storageAccount.id
    workspaceId: logAnalytics.id
  }
}

output vNetName string = vnet.name
output subnets array = vnet.properties.subnets

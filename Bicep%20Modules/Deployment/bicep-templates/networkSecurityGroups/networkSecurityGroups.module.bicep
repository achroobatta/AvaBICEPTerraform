@description('Virtual network object')
param nsgObject object
param location string
param name string
param tags object
// Needed to remove object reference from json(loadTextContent('./sharedRules.json')).securityRules as checkov wouldn't lint this
var sharedRules = json(loadTextContent('./sharedRules.json'))

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

resource nsg 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: name
  tags: tags
  location: location
  properties: {
    securityRules: concat(sharedRules.securityRules, nsgObject.rules)
  }
}

resource diagnostics 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = {
  scope: nsg
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
    storageAccountId: storageAccount.id
    workspaceId: logAnalytics.id
  }
}

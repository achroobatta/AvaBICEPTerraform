@description('Application Security Object')
param pipObject object
param tags object
param name string
param location string
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

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: name
  tags: tags
  location: location
  sku: {
    name: pipObject.skuName
    tier: pipObject.tierName
  }
  properties: {
    deleteOption: 'Detach'
    idleTimeoutInMinutes: 15
    publicIPAddressVersion: pipObject.publicIPAddressVersion
    publicIPAllocationMethod: pipObject.publicIPAllocationMethod
  }
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  scope: publicIpAddress
  properties: {
    logAnalyticsDestinationType: null
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          days: 60
          enabled: true
        }
      }
      {
        categoryGroup: 'audit'
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

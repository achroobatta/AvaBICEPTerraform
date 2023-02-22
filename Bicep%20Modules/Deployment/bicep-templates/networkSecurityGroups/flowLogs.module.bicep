// Params from the *.parameters.json file
param nsgObject object

// Params from the global.yml VGS
param location string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string
param nsgName string
param networkGroup string
param flName string

//var flowlogName = 'flowlog'
var networkWatcherName = 'NetworkWatcher_${location}'

// Existing resources required
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}
resource nsg 'Microsoft.Network/networkSecurityGroups@2020-05-01' existing = {
  name: nsgName
  scope: resourceGroup(subscription().subscriptionId,networkGroup)
}

resource networkWatcher 'Microsoft.Network/networkWatchers@2021-02-01' = {
  name: networkWatcherName
  location: location
  properties: {}
}

resource nsgFlowLog 'Microsoft.Network/networkWatchers/flowLogs@2021-02-01' = {
  name: '${networkWatcherName}/${flName}'
  location: location
  properties: {
    enabled: nsgObject.enableFlowLogs
    flowAnalyticsConfiguration: {
      networkWatcherFlowAnalyticsConfiguration: {
        enabled: empty(logAnalytics.id) ? false : true
        trafficAnalyticsInterval: 60
        workspaceResourceId: empty(logAnalytics.id) ? null : logAnalytics.id
      }
    }
    format: {
      type: 'JSON'
      version: 2
    }
    retentionPolicy: {
      days: nsgObject.flowLogsStorageRetention
      enabled: true
    }
    storageId: storageAccount.id
    targetResourceId: nsg.id
  }
  dependsOn: [
    networkWatcher
  ]
}

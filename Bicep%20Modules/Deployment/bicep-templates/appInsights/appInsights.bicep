// targetScope = 'resourceGroup'
// Params from the *.parameters.json file
param appinsightsObject object

@description('Type of flow for the App insights Instance')
param appInsightsFlowType string = 'Redfield'

// Params from the global.yml VGS
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string
param location string
param appiPrefix string


param deployDate string
param environmentType string

var name = '${appiPrefix}${appinsightsObject.name}'

@description('Source of Azure Resource Manager deployment')
param appInsightsRequestSource string = 'CustomDeployment'

resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}


resource appInsights 'microsoft.insights/components@2020-02-02' = {
  name: name
  location: location
  kind: appinsightsObject.kind
  tags:{
    Environment: environmentType
    DeployDate: deployDate
    Owner: resourceGroup().tags['Owner']
    CostCentre: resourceGroup().tags['CostCentre']
    Application: resourceGroup().tags['Application']
  }
  properties: {
    Application_Type: appinsightsObject.type
    Flow_Type: appInsightsFlowType
    Request_Source: appInsightsRequestSource
    WorkspaceResourceId: logAnalytics.id
  }
}


resource appInsightsDiagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  scope: appInsights
  properties: {
    workspaceId: logAnalytics.id
    storageAccountId: storageAccount.id
    logs: [
      {
        category: 'AppAvailabilityResults'
        enabled: true
      }
      {
        category: 'AppBrowserTimings'
        enabled: true
      }
      {
        category: 'AppEvents'
        enabled: true
      }
      {
        category: 'AppMetrics'
        enabled: true
      }
      {
        category: 'AppDependencies'
        enabled: true
      }
      {
        category: 'AppExceptions'
        enabled: true
      }
      {
        category: 'AppPageViews'
        enabled: true
      }
      {
        category: 'AppPerformanceCounters'
        enabled: true
      }
      {
        category: 'AppRequests'
        enabled: true
      }
      {
        category: 'AppSystemEvents'
        enabled: true
      }
      {
        category: 'AppTraces'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
    }
    ]
  }
  dependsOn: []
}

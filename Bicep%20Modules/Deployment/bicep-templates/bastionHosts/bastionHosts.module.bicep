targetScope = 'resourceGroup'
// Params from the *.parameters.json file
param bastionHostObject object

param vnPrefix string
param pipPrefix string
param location string
param name string
param networkGroup string

param tags object
// Logging params
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string
//load metric alerts to be applied to all bastion hosts
var metricAlertsObject = json(loadTextContent('./metricAlerts.json'))

// Existing resources required
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${vnPrefix}${bastionHostObject.vnetName}/AzureBastionSubnet'
  scope: resourceGroup(networkGroup)
}
resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = {
  name: '${pipPrefix}${bastionHostObject.pip}'
  scope: resourceGroup(networkGroup)
}

// Existing resources required
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}
resource actionGroup 'Microsoft.Insights/actionGroups@2022-04-01' existing = {
  name: metricAlertsObject.actionGroupName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}

resource bastionHosts 'Microsoft.Network/bastionHosts@2021-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: bastionHostObject.sku
  }
  properties: {
    disableCopyPaste: false
    enableFileCopy: true
    // enableIpConnect: true
    // enableShareableLink: true
    enableTunneling: true
    ipConfigurations: [
      {
        name: name
        properties: {
          privateIPAllocationMethod: bastionHostObject.privateIPAllocationMethod
          publicIPAddress: {
            id: publicIpAddress.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
    scaleUnits: bastionHostObject.scaleUnits
  }
}


resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  scope: bastionHosts
  properties: {
    logAnalyticsDestinationType: null
    logs: [
      {
        category: 'BastionAuditLogs'
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

resource metricAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = [for metricAlert in metricAlertsObject.metricAlerts: {
  name: '${metricAlert.name} (${bastionHosts.name})'
  location: 'global'    //must be global
  tags: tags
  properties: {
    actions: [
      {
        actionGroupId: actionGroup.id
        webHookProperties: {}
      }
    ]
    autoMitigate: true
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: metricAlert.CriterionType
          dimensions:empty(metricAlert.dimensions)?[]:[ //if not empty
            {
                name: metricAlert.dimensions
                operator: 'Include'
                values: [
                    '*'
                ]
            }
        ]
          metricName: metricAlert.metricName
          metricNamespace: 'string'
          name: 'Metric1'
          operator: metricAlert.operator
          skipMetricValidation: true
          threshold: metricAlert.threshold
          timeAggregation: metricAlert.timeAggregation
        }
      ]
    }
    description: metricAlert.name
    enabled: true
    evaluationFrequency: 'PT5M'
    scopes: [
      bastionHosts.id
    ]
    severity: metricAlert.severity
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Network/bastionHosts'
    windowSize: 'PT5M'
  }
}]

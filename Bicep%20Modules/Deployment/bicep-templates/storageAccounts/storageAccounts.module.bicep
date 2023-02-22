targetScope = 'resourceGroup'
param storageAccountObject object
param tags object
param name string
param location string
param workspaceGroup string
param hubSubscription string

//load metric alerts to be applied to all storage accounts
var metricAlertsObject = json(loadTextContent('./metricAlerts.json'))

resource actionGroup 'Microsoft.Insights/actionGroups@2022-04-01' existing = {
  name: metricAlertsObject.actionGroupName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}

//TODO document how to add metric alerts to pipeline



resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' = {
  name: name
  tags: tags
  location: location
  sku: {
    name: storageAccountObject.sku
  }
  kind: storageAccountObject.kind
  identity: {
    type: storageAccountObject.identity
  }
  properties: {
    accessTier: storageAccountObject.accessTier
    allowBlobPublicAccess: false
    allowCrossTenantReplication: false
    allowSharedKeyAccess: true
    defaultToOAuthAuthentication: false
    keyPolicy: {
      keyExpirationPeriodInDays: 90
    }
    minimumTlsVersion: 'TLS1_2'
    networkAcls: contains(storageAccountObject, 'networkAcls') ?{
      bypass: 'string'
      defaultAction: 'string'
      ipRules: [
        {
          action: 'Allow'
          value: 'string'
        }
      ]
      resourceAccessRules: [
        {
          resourceId: 'string'
          tenantId: 'string'
        }
      ]
      virtualNetworkRules: [
        {
          action: 'Allow'
          id: 'string'
          state: 'string'
        }
      ]
    } : null
    publicNetworkAccess: storageAccountObject.publicNetworkAccess
    routingPreference: contains(storageAccountObject,'routingPreference')? {
      publishInternetEndpoints: true
      publishMicrosoftEndpoints: true
      routingChoice: 'string'
    } : null
    supportsHttpsTrafficOnly: true
  }
}


resource metricAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = [for metricAlert in metricAlertsObject.metricAlerts: {
  name: '${metricAlert.name} (${storageAccount.name})'
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
      storageAccount.id
    ]
    severity: metricAlert.severity
    targetResourceRegion: location
    targetResourceType: 'Microsoft.Storage/storageAccounts'
    windowSize: 'PT5M'
  }
}]

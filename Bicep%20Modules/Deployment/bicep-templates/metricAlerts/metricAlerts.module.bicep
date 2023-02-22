targetScope = 'resourceGroup'
param metricAlertsObject object
param tags object


resource actionGroup 'Microsoft.Insights/actionGroups@2022-04-01' existing = {
  name: metricAlertsObject.actionGroupName
  scope: resourceGroup()
}


resource metricAlerts 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertsObject.name
  location: 'global'    //must be global
  tags: tags
  properties: {
    actions: [
      {
        actionGroupId: actionGroup.id
        webHookProperties: {}
      }
    ]
    autoMitigate: metricAlertsObject.autoMitigate
    criteria: {
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
      allOf: [
        {
          criterionType: metricAlertsObject.CriterionType
          dimensions:empty(metricAlertsObject.dimensions)?[]:[ //if not empty
            {
                name: metricAlertsObject.dimensions
                operator: 'Include'
                values: [
                    '*'
                ]
            }
        ]
          metricName: metricAlertsObject.metricName
          metricNamespace: 'string'
          name: 'Metric1'
          operator: metricAlertsObject.operator
          skipMetricValidation: true
          threshold: metricAlertsObject.threshold
          timeAggregation: metricAlertsObject.timeAggregation
        }
      ]
    }
    description: metricAlertsObject.name
    enabled: metricAlertsObject.enabled
    evaluationFrequency: metricAlertsObject.evaluationFrequency
    scopes: [
      metricAlertsObject.scopes
    ]
    severity: metricAlertsObject.severity
    targetResourceRegion: metricAlertsObject.targetResourceRegion
    targetResourceType: metricAlertsObject.targetResourceType
    windowSize: metricAlertsObject.windowSize
  }
}

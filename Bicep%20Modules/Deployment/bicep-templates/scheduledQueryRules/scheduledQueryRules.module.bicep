targetScope = 'resourceGroup'
param scheduledQueryRulesObject object
param dimensions array
param tags object
param name string
param workspaceName string
param workspaceGroup string
param location string

//TODO make this flexible enough to accept multiple actiongroups

resource emailActionGroup 'Microsoft.Insights/actionGroups@2022-04-01' existing = {
  name: scheduledQueryRulesObject.actionGroupName
  scope: resourceGroup()
}

// Always in the same subscription as LAWS 
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(workspaceGroup)
}

resource scheduledQueryRules 'Microsoft.Insights/scheduledQueryRules@2021-08-01' = {
  name: name
  location: location
  tags: tags
  kind: scheduledQueryRulesObject.kind
  properties: {
    description: scheduledQueryRulesObject.name
    displayName: scheduledQueryRulesObject.name
    enabled: scheduledQueryRulesObject.enabled
    evaluationFrequency: scheduledQueryRulesObject.evaluationFrequency
    severity: scheduledQueryRulesObject.severity
    scopes: [
      logAnalytics.id
    ]
    autoMitigate: scheduledQueryRulesObject.autoMitigate
    checkWorkspaceAlertsStorageConfigured: false

    windowSize: scheduledQueryRulesObject.windowSize
    actions: {
      actionGroups: [
        emailActionGroup.id
      ]
      customProperties: {}
    }
    criteria: {
      allOf: [  //Dimension in API doco  https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/scheduledqueryrules?tabs=bicep#dimension
        {
          dimensions: [ for dimension in dimensions: {
              name: dimension
              operator: 'Include'
              values: [
                '*'
              ]
          }]
          
          failingPeriods: {   //ConditionFailingPeriods in API doco https://docs.microsoft.com/en-us/azure/templates/microsoft.insights/scheduledqueryrules?tabs=bicep#conditionfailingperiods
            minFailingPeriodsToAlert: scheduledQueryRulesObject.minFailingPeriodsToAlert
            numberOfEvaluationPeriods: scheduledQueryRulesObject.numberOfEvaluationPeriods
          }
          metricMeasureColumn: scheduledQueryRulesObject.conditionMetricMeasureColumn
          // metricName: 'string' //only used to log type LogtoMetric
          operator: scheduledQueryRulesObject.conditionOperator
          query: scheduledQueryRulesObject.conditionQuery
          resourceIdColumn: scheduledQueryRulesObject.conditionResourceIdColumn
          threshold: scheduledQueryRulesObject.conditionThreshold
          timeAggregation: scheduledQueryRulesObject.conditionTimeAggregation
        }
      ]
    }
    // Values are not used
    // muteActionsDuration: 'string'
    //overrideQueryTimeRange: 'string'
    // skipQueryValidation: bool
    // targetResourceTypes: [
    //   emailActionGroup.id
    // ]
  }
}

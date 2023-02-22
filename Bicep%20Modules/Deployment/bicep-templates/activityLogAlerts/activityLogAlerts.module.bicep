targetScope = 'resourceGroup'
param activityLogAlertsObject object
param tags object
param name string

param location string

//TODO make this flexible enough to accept multiple actiongroups
//TODO remove hardcoded subscription for scopes
resource emailActionGroup 'Microsoft.Insights/actionGroups@2022-04-01' existing = {
  name: activityLogAlertsObject.actionGroupName
  scope: resourceGroup()
}

resource activityLogAlerts 'Microsoft.Insights/activityLogAlerts@2020-10-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    enabled: activityLogAlertsObject.enabled
    scopes: [
      activityLogAlertsObject.scopes
    ]
    actions: {
      actionGroups: [
        {
          actionGroupId: emailActionGroup.id
          webhookProperties: {}
        }
      ]
    }
    condition: {
      allOf: activityLogAlertsObject.conditions
    }

  }
}

targetScope = 'resourceGroup'
param actionGroupsObject object
param tags object


param location string


resource actionGroups 'Microsoft.Insights/actionGroups@2022-04-01' = {
  name: actionGroupsObject.name
  location: location
  tags: tags
  properties: {
    enabled: true
    groupShortName: 'string'
    emailReceivers: actionGroupsObject.emailReceivers
    smsReceivers: actionGroupsObject.smsReceivers

  }
}

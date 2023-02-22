// Params from the *.parameters.json file
param activityLogAlertsObject object

//pipeline parameters
param environmentType string
param deployDate string

module activityLogAlertsModule './activityLogAlerts.module.bicep' = [for activityLogAlerts in activityLogAlertsObject.activityLogAlerts:{
  name: replace(activityLogAlerts.name, ' ','-') //Replace spaces
  scope: resourceGroup()
  params: {
    activityLogAlertsObject: activityLogAlerts
    location: 'global'                  // Must be global
    name: activityLogAlerts.name
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

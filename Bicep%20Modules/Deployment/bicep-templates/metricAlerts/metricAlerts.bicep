// Params from the *.parameters.json file
param metricAlertsObject object

// Tagging parameters
param environmentType string
param deployDate string

// Params from the global.yml VGS

module metricAlertsModule './metricAlerts.module.bicep' = [for metricAlerts in metricAlertsObject.metricAlerts:{
  name: replace(metricAlerts.name, ' ','-') 
  scope: resourceGroup()
  params: {
    metricAlertsObject: metricAlerts
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

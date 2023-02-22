// Params from the *.parameters.json file
param actionGroupsObject object

// Tagging parameters
@description('Type of environment the action gets deployed to')
param environmentType string
@description('Deployment Date')
param deployDate string

// Params from the global.yml VGS

module actionGroupsModule './actionGroups.module.bicep' = [for actionGroups in actionGroupsObject.actionGroups:{
  name: actionGroups.name
  scope: resourceGroup()
  params: {
    actionGroupsObject: actionGroups
    location: 'global'                  // Must be global
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

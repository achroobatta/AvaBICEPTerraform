// Params from the *.parameters.json file
param scheduledQueryRulesObject object

//pipeline parameters
param location string
param environmentType string
param deployDate string
param workspaceName string
param workspaceGroup string


module scheduledQueryRulesModule './scheduledQueryRules.module.bicep' = [for scheduledQueryRules in scheduledQueryRulesObject.scheduledQueryRules:{
  name: replace(scheduledQueryRules.name, ' ','-') //Replace spaces
  scope: resourceGroup()
  params: {
    scheduledQueryRulesObject: scheduledQueryRules
    location: location
    name: scheduledQueryRules.name
    dimensions: split(scheduledQueryRules.dimensionNames,',')
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

// Params from the *.parameters.json file
param asgObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param asgPrefix string
param networkGroup string

module asgModule './applicationSecurityGroups.module.bicep' = [for asg in asgObject.asg:{
  // create network with auto created prefix based on location and environment name
  name: '${asgPrefix}${asg.name}'
  //always deploy into the network resource group based on location
  scope: resourceGroup(networkGroup)
  params: {
    name: '${asgPrefix}${asg.name}'
    location: location
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

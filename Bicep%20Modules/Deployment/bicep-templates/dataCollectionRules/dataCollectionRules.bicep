// Params from the *.parameters.json file
param dataCollectionRulesObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param dcrPrefix string
param workspaceGroup string
param workspaceName string
param hubSubscription string

module dataCollectionRulesModule './dataCollectionRules.module.bicep' = [for dataCollectionRules in dataCollectionRulesObject.dataCollectionRules:{
  // create network with auto created prefix based on location and environment name
  name: '${dcrPrefix}${dataCollectionRules.osType}'
  //always deploy into the network resource group based on location
  scope: resourceGroup(workspaceGroup)
  params: {
    dataCollectionRulesObject: dataCollectionRules
    name: '${dcrPrefix}${toLower(dataCollectionRules.osType)}'
    workspaceGroup: workspaceGroup
    workspaceName: workspaceName
    hubSubscription: hubSubscription
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

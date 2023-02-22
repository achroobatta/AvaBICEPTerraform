// Params from the *.parameters.json file
param storageAccountObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string
param hubSubscription string

// Params from the global.yml VGS
param saPrefix string
param storageGroup string
param workspaceGroup string

module storageAccountModule './storageAccounts.module.bicep' = [for storageAccount in storageAccountObject.storageAccount:{
  // create network with auto created prefix based on location and environment name
  name: '${saPrefix}${storageAccount.name}'
  //always deploy into the network resource group based on location
  scope: resourceGroup(storageGroup)
  params: {
    storageAccountObject: storageAccount
    name: '${saPrefix}${storageAccount.name}'
    hubSubscription: hubSubscription
    location: location
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

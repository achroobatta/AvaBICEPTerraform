// Params from the *.parameters.json file
param avsObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param avsPrefix string
param computeGroup string

module avsModule './availabilitySets.module.bicep' = [for avs in avsObject.avs:{
  // create network with auto created prefix based on location and environment name
  name: '${avsPrefix}${avs.name}'
  //always deploy into the network resource group based on location
  scope: resourceGroup(computeGroup)
  params: {
    avsObject: avs
    avsPrefix: avsPrefix
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

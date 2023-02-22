// Params from the *.parameters.json file
param addsObject object

// Params from the global.yml VGS
param networkGroup string
param location string
param vnPrefix string

// Tagging parameters
param environmentType string
param deployDate string

module addsModule './adds.module.bicep' = [for adds in addsObject.adds:{
  name: adds.domainName
  scope: resourceGroup(networkGroup)
  params: {
    addsObject: adds
    location: location
    vnPrefix: vnPrefix
    networkGroup: networkGroup
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

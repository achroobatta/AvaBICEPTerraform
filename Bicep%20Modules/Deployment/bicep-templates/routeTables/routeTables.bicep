@description('Route Tables')
param rtObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param rtPrefix string
param fwPrefix string
param udrPrefix string
param networkGroup string

module rtModule './routeTables.module.bicep' = [for rt in rtObject.rt:{
  name: '${rtPrefix}${rt.name}'
  scope: resourceGroup(networkGroup)
  params: {
    rtObject: rt
    rtPrefix: rtPrefix
    fwPrefix: fwPrefix
    networkGroup: networkGroup
    location: location
    udrPrefix: udrPrefix
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]


// Params from the *.parameters.json file
param vnetObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param vnPrefix string
param snPrefix string
param nsgPrefix string
param networkGroup string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string

module vnetModule './virtualNetworks.module.bicep' = [for vnet in vnetObject.vnet:{
  // create network with auto created prefix based on location and environment name
  name: '${vnPrefix}${vnet.name}'
  //always deploy into the network resource group based on location
  scope: resourceGroup(networkGroup)
  params: {
    vnetObject: vnet
    location: location
    name: '${vnPrefix}${vnet.name}'
    snPrefix: snPrefix
    nsgPrefix: nsgPrefix
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    hubSubscription: hubSubscription
    loggingStorageAccountName: loggingStorageAccountName
    loggingStorageAccountGroup: loggingStorageAccountGroup
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

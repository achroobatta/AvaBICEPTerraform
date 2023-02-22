// Params from the *.parameters.json file
param vgwObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param vgwPrefix string
param vnPrefix string
param pipPrefix string
param networkGroup string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string


module vnetModule './virtualNetworkGateways.module.bicep' = [for vgw in vgwObject.vgw:{
  // create network with auto created prefix based on location and environment name
  name: '${vgwPrefix}${vgw.name}'
  //always deploy into the network resource group based on location
  scope: resourceGroup(networkGroup)
  params: {
    vgwObject: vgw
    location: location
    name: '${vgwPrefix}${vgw.name}'
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    networkGroup: networkGroup
    pipPrefix: pipPrefix
    vnPrefix: vnPrefix
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

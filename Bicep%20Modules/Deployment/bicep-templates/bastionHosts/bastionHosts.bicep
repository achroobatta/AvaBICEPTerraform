// Params from the *.parameters.json file
param bastionHostObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param vnPrefix string
param pipPrefix string
param networkGroup string
param bstPrefix string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string


module bastionHostModule './bastionHosts.module.bicep' = [for bastionHost in bastionHostObject.bastionHost:{
  name: '${bstPrefix}${bastionHost.name}'
  scope: resourceGroup(networkGroup)
  params: {
    bastionHostObject: bastionHost
    name: '${bstPrefix}${bastionHost.name}'
    networkGroup:networkGroup
    pipPrefix:pipPrefix
    vnPrefix:vnPrefix
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    hubSubscription: hubSubscription
    loggingStorageAccountName: loggingStorageAccountName
    loggingStorageAccountGroup: loggingStorageAccountGroup
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



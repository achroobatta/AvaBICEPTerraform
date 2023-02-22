// Params from the *.parameters.json file
param pipObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param pipPrefix string
param networkGroup string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string

module pipModule './publicIpAddresses.module.bicep' = [for pip in pipObject.pip:{
  name: '${pipPrefix}${pip.name}'
  scope: resourceGroup(networkGroup)
  params: {
    pipObject: pip
    name: '${pipPrefix}${pip.name}'
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

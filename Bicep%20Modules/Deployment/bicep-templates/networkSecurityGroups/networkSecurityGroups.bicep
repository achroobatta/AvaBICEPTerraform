// Params from the *.parameters.json file
param nsgObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param nsgPrefix string
param flPrefix string
param networkGroup string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string


// Need to serialise this deployment as it generated timimng errors
@batchSize(1)
module nsgModule './networkSecurityGroups.module.bicep' = [for nsg in nsgObject.nsg:{
  name: '${nsgPrefix}${nsg.name}'
  scope: resourceGroup(networkGroup)
  params: {
    nsgObject: nsg
    name:'${nsgPrefix}${nsg.name}'
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

// Need to serialise this deployment as it generated timimng errors
@batchSize(1)
module flowLogsModule './flowLogs.module.bicep' = [for nsg in nsgObject.nsg:{
  name: '${flPrefix}${nsg.name}'
  scope: resourceGroup('NetworkWatcherRG')
  params: {
    nsgObject: nsg
    nsgName: '${nsgPrefix}${nsg.name}'
    flName: '${flPrefix}${nsg.name}'
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    networkGroup: networkGroup
    hubSubscription: hubSubscription
    loggingStorageAccountName: loggingStorageAccountName
    loggingStorageAccountGroup: loggingStorageAccountGroup
    location: location
  }
  dependsOn: [
    nsgModule
  ]
}]

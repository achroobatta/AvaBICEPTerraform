// Params from the *.parameters.json file
param keyVaultObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param kvPrefix string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string
param securityGroup string

module keyVaultModule './keyVaults.module.bicep' = [for keyVault in keyVaultObject.keyVault:{
  name: '${kvPrefix}${keyVault.name}'
  scope: resourceGroup(securityGroup)
  params: {
    keyVaultObject: keyVault
    name: '${kvPrefix}${keyVault.name}'
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



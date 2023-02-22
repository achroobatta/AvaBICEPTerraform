// Params from the *.parameters.json file
param vmObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param vmPrefix string
param loggingStorageAccountName string
param dataCollectionPrefix string
param keyvaultAdminCreds string
param securityGroup string
param computeGroup string
param networkGroup string
param vnPrefix string
param asgPrefix string
param avsPrefix string
param snPrefix string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountGroup string

// Need to get admin passwords from the vault
resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' existing = {
  name: keyvaultAdminCreds
  scope: resourceGroup(subscription().subscriptionId, securityGroup)
}

module vmModule './virtualMachines.module.bicep' = [for vm in vmObject.vm:{
  name: '${vmPrefix}${vm.name}'
  scope: resourceGroup(computeGroup)
  params: {
    vmObject: vm
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    hubSubscription: hubSubscription
    dataCollectionPrefix: dataCollectionPrefix
    loggingStorageAccountGroup: loggingStorageAccountGroup
    name: '${vmPrefix}${vm.name}'
    adminUserName: keyVault.getSecret('adminUserName')
    adminPassword: keyVault.getSecret('adminPassword')
    location: location
    networkGroup: networkGroup
    vnPrefix: vnPrefix
    asgPrefix: asgPrefix
    avsPrefix: avsPrefix
    snPrefix: snPrefix
    computeGroup: computeGroup
    loggingStorageAccountName: loggingStorageAccountName
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

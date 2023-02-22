@description('Azure Firewalls')
param fwObject object

// Params from the global.yml VGS
param workspaceName string
param workspaceGroup string
param hubSubscription string
param networkGroup string
param fwPrefix string
param fwpPrefix string
param pipPrefix string
param location string
param vnPrefix string

// Tagging parameters
param environmentType string
param deployDate string

module fwModule './azureFirewalls.module.bicep' = [for fw in fwObject.fw:{
  name: '${fwPrefix}${fw.name}'
  scope: resourceGroup(networkGroup)
  params: {
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    hubSubscription: hubSubscription
    networkGroup: networkGroup
    fwPrefix: fwPrefix
    fwpPrefix: fwpPrefix
    pipPrefix: pipPrefix
    vnPrefix: vnPrefix
    location: location
    fwObject: fw
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags['Owner']
      CostCentre: resourceGroup().tags['CostCentre']
      Application: resourceGroup().tags['Application']
    }
  }
}]

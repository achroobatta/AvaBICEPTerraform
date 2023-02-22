targetScope = 'subscription'
// Params from the *.parameters.json file
param resourceGroupObject object

// Tagging parameters
param location string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param rgPrefix string

resource resourceGroups 'Microsoft.Resources/resourceGroups@2020-10-01' = [for resourceGroup in resourceGroupObject.resourceGroup: {
  name: resourceGroup.builtin ? resourceGroup.name : '${rgPrefix}${resourceGroup.name}'
  location: location
  tags: {
    Application: resourceGroup.application
    Environment: environmentType
    Owner: resourceGroup.owner
    CostCentre: resourceGroup.costCentre
    DeployDate: deployDate
  }
}]


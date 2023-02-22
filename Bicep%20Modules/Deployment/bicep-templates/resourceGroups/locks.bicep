// Params from the *.parameters.json file
param resourceGroupObject object
param rgPrefix string

module locksModule './locks.module.bicep' = [for resourceGroup in resourceGroupObject.resourceGroup: {
  name: 'CanNotDelete-${rgPrefix}${resourceGroup.name}'
  scope: resourceGroup(resourceGroup.builtin ? resourceGroup.name : '${rgPrefix}${resourceGroup.name}')
  params:{
    name: 'CanNotDelete-${rgPrefix}${resourceGroup.name}'
  }
}]

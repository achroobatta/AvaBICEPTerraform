// Params from the *.parameters.json file
param resourceGroupObject object
param rgPrefix string
param deployDate string
targetScope = 'resourceGroup'


module policyExemptionModule './policyExemptions.module.bicep' = [for resourceGroup in resourceGroupObject.resourceGroup:  {
  name: 'PolicyExemption-${rgPrefix}${resourceGroup.name}'
  scope: resourceGroup(resourceGroup)
  params: {
    deployDate: deployDate
  }
}]


// Params from the *.parameters.json file
param policyDefinitionObject object
targetScope = 'managementGroup'

module policyDefinitionModule './policyDefinitions.module.bicep' = [for policyDefintion in policyDefinitionObject.policyDefintion:{
  name: 'Allow-Only-AustraliaEast-and-AustraliaEast-Resources'
  scope: managementGroup(policyDefintion.managementGroup)
  params: {
    policyDefinitionObject:policyDefintion
  }
}]

// Params from the *.parameters.json file
param deployDate string
targetScope = 'resourceGroup'


resource policyExemptions 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: 'string'
  properties: {
    description: 'This resource group is not restricted'
    displayName: 'This resource group is not restricted'
    exemptionCategory: 'Waiver'
    expiresOn: 'string'
    metadata: {
      lastUpdated: deployDate
    }
    policyAssignmentId: 'string'
    policyDefinitionReferenceIds: [
      'string'
    ]
  }
}


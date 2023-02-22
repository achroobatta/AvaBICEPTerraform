targetScope = 'managementGroup'
// Params from the *.parameters.json file
param policyAssignmentObject object
param location string

resource policyAssignments 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: '${policyAssignmentObject.policyName}-${policyAssignmentObject.managementGroup}'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    policyDefinitionId: policyAssignmentObject.policyDefinitionId
    nonComplianceMessages: [
      {
        message: policyAssignmentObject.nonComplianceMessage
      }
    ]
  }

}


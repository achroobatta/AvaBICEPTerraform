// Params from the *.parameters.json file
param policyAssignmentObject object
param location string
targetScope = 'managementGroup'

module policyAssignmentModule './policyAssignments.module.bicep' = [for policyAssignment in policyAssignmentObject.policyAssignment:{
  name: 'Assign-${policyAssignment.policyName}-to-${policyAssignment.managementGroup}'
  
  scope: managementGroup(policyAssignment.managementGroup)
  params: {
    policyAssignmentObject:policyAssignment
    location: location
  }
}]

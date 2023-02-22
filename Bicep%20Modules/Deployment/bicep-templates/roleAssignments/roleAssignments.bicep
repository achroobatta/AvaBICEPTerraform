// Params from the *.parameters.json file
param roleAssignmentObject object

// Params from the global.yml VGS
param rgPrefix string

module roleAssignmentModule './roleAssignments.module.bicep' = [for roleAssignment in roleAssignmentObject.roleAssignment:{
  name: '${rgPrefix}${roleAssignment.name}'
  scope: resourceGroup('${rgPrefix}${roleAssignment.resourceGroup}')
  params: {
    roleAssignmentObject: roleAssignment
  }
}]



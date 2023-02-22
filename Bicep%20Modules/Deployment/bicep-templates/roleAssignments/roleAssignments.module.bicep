targetScope = 'resourceGroup'
// Params from the *.parameters.json file
param roleAssignmentObject object

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: roleAssignmentObject.roleId
}
// To cleanup resources Get-AzRoleAssignment -ObjectId 154823d4-eb94-4ac0-abff-2a388d664eb3 | Remove-AzRoleAssignment
// Where objectID is the principalID
resource keyvaultReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(resourceGroup().id, roleAssignmentObject.principalId, roleDefinition.id)
  properties: {
    roleDefinitionId: roleDefinition.id
    principalId: roleAssignmentObject.principalId
    principalType: roleAssignmentObject.principalType
  }
}

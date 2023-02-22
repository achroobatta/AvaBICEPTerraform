targetScope = 'tenant'
// Params from the *.parameters.json file
param roleDefinitionObject object

resource roleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' = [for roleDefinition in roleDefinitionObject.roleDefinition:{
  name: guid(tenant().tenantId, string(roleDefinition.actions))
  properties: {
    roleName: roleDefinition.roleName
    description: roleDefinition.description
    type: 'customRole'
    permissions: [
      {
        actions: roleDefinition.actions
        notActions: roleDefinition.notActions
      }
    ]
    // Using tenant root group (which is the same as the AAD tenant) because only one MG can be specified
    assignableScopes:roleDefinition.assignableScopes
  }
}]


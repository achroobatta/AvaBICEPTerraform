// From bicep template
param name string
param location string
param tags object

resource applicationSecuritygroups 'Microsoft.Network/applicationSecurityGroups@2021-05-01' = {
  name: name
  location: location
  properties: null
  tags: tags
}

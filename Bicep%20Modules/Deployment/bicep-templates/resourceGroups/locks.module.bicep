targetScope = 'resourceGroup'

param name string

resource resourceLocks 'Microsoft.Authorization/locks@2017-04-01'={
  name: name
  properties: {
    level: 'CanNotDelete'
  }
}

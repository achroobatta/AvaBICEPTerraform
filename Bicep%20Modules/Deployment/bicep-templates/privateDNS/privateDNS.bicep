@description('Private Dns Zone name')
param privateDnsZoneName string

@description('Private Dns Zone location')
param location string = 'global'

@description('Link Private Dns Zone to an existing Virtual Network')
param enableVnetLink bool = false

@description('Existing Virtual Network resource Id. Only required if enableVnetLink equals true.')
param vnetResourceId string = ''

@description('Enable auto-registration of virtual machine records for Private Dns Zone')
param registrationEnabled bool = false

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: location
}

resource privateDnsZoneVnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = if (enableVnetLink) {
  parent: privateDnsZone
  name: !empty(vnetResourceId) ? split(vnetResourceId, '/')[8] : 'null'
  location: location
  properties: {
    registrationEnabled: registrationEnabled
    virtualNetwork: {
      id: vnetResourceId
    }
  }
}

output name string = privateDnsZone.name
output id string = privateDnsZone.id

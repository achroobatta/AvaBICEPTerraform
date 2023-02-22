@description('Private DNS zone name')
param privateDnsZoneName string

@description('Enable automatic VM DNS registration in the zone')
param vmRegistration bool = true

@description('Name of the virtual network for linking')
param vnetName string

var location = 'global'

resource privateDnsZoneName_resource 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: location
}

resource privateDnsZoneName_vnetName_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZoneName_resource
  name: '${vnetName}-link'
  location: location
  properties: {
    registrationEnabled: vmRegistration
    virtualNetwork: {
      id: resourceId('Microsoft.Network/virtualNetworks', vnetName)
    }
  }
}

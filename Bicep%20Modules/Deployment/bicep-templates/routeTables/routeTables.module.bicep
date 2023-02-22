@description('RouteTables')
param rtObject object
param networkGroup string
param fwPrefix string
param rtPrefix string
param udrPrefix string
param location string
param tags object

//In the same resource group as the firewall
resource azureFirewall 'Microsoft.Network/azureFirewalls@2021-05-01' existing =  {
  name: '${fwPrefix}hub-01' //Need to conisder ase
  scope: resourceGroup(networkGroup)
}

resource routeTable 'Microsoft.Network/routeTables@2021-05-01' = {
  name: '${rtPrefix}${rtObject.name}'
  location: location
  tags: tags
  properties: {
    disableBgpRoutePropagation: rtObject.disableBgpRoutePropagation
    routes:[for route in rtObject.routes: {
        name: '${udrPrefix}${route.name}'
        properties: {
          addressPrefix: route.addressPrefix
          hasBgpOverride: route.hasBgpOverride
          nextHopIpAddress: (route.nextHopType == 'Internet') ? null : azureFirewall.properties.ipConfigurations[0].properties.privateIPAddress 
          nextHopType: route.nextHopType
        }
        type: 'Microsoft.Network/routeTables'
      }]
  }
}

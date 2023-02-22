@description('Name of the ExpressRoute circuit')
param circuitName string = ''

@description('autonomous system number used to create private peering between the customer edge router and MSEE routers')
param peerASN int = 65001

@description('point-to-point network prefix of primary link between the customer edge router and MSEE router')
param primaryPeerAddressPrefix string = '192.168.10.16/30'

@description('point-to-point network prefix of secondary link between the customer edge router and MSEE router')
param secondaryPeerAddressPrefix string = '192.168.10.20/30'

@description('VLAN Id used between the customer edge routers and MSEE routers. primary and secondary link have the same VLAN Id')
param vlanId int = 100

resource circuitName_AzurePrivatePeering 'Microsoft.Network/expressRouteCircuits/peerings@2021-05-01' = {
  name: '${circuitName}/AzurePrivatePeering'
  properties: {
    peeringType: 'AzurePrivatePeering'
    peerASN: peerASN
    primaryPeerAddressPrefix: primaryPeerAddressPrefix
    secondaryPeerAddressPrefix: secondaryPeerAddressPrefix
    vlanId: vlanId
  }
}

output CircuitName string = circuitName

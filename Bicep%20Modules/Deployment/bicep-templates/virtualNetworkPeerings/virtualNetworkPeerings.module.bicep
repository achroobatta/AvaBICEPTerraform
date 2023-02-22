
param vnetPeeringObject object
param remoteSubscription string
param name string
param remoteVirtualNetworkGroup string
param remoteVirtualNetworkName string

resource remoteVirtualNetwork 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: remoteVirtualNetworkName
  scope: resourceGroup(remoteSubscription,remoteVirtualNetworkGroup)
}

resource virtualNetworkPeerings 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  name: name
  properties: {
    allowVirtualNetworkAccess: vnetPeeringObject.allowVirtualNetworkAccess
    allowForwardedTraffic: vnetPeeringObject.allowForwardedTraffic
    allowGatewayTransit: vnetPeeringObject.allowGatewayTransit
    useRemoteGateways: vnetPeeringObject.useRemoteGateways
    remoteVirtualNetwork: {
      id: remoteVirtualNetwork.id
    }
  }
}


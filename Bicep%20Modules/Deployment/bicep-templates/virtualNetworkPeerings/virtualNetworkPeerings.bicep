// Params from the *.parameters.json file
param vnetPeeringObject object

// Params from the global.yml VGS
param networkGroup string
param hubSubscription string 
param environmentType string

//peering to hub
module vnetlocalPeeringsModule './virtualNetworkPeerings.module.bicep' = [for peering in vnetPeeringObject.vnetPeering:{
  name: 'vn-${environmentType}-${peering.spokeVirtualNetworkName}-to-vn-${environmentType}-${peering.hubVirtualNetworkName}'
  scope: resourceGroup(networkGroup)
  params: {
    vnetPeeringObject: peering
    name: 'vn-${environmentType}-${peering.spokeVirtualNetworkName}/vn-${environmentType}-${peering.spokeVirtualNetworkName}-to-vn-${environmentType}-${peering.hubVirtualNetworkName}'
    //hub subscription
    remoteSubscription: hubSubscription
    remoteVirtualNetworkGroup:'rg-${environmentType}-${peering.hubVirtualNetworkGroup}'
    remoteVirtualNetworkName: 'vn-${environmentType}-${peering.hubVirtualNetworkName}'
  }
  
}]

//Peering from hub
module vnetremotePeeringsModule './virtualNetworkPeerings.module.bicep' = [for peering in vnetPeeringObject.vnetPeering:{
  name: 'vn-${environmentType}-${peering.hubVirtualNetworkName}-to-vn-${environmentType}-${peering.spokeVirtualNetworkName}'
  scope: resourceGroup(hubSubscription,'rg-${environmentType}-ae-network') 
  params: {
    vnetPeeringObject: peering
    name: 'vn-${environmentType}-${peering.hubVirtualNetworkName}/vn-${environmentType}-${peering.hubVirtualNetworkName}-to-vn-${environmentType}-${peering.spokeVirtualNetworkName}'
    // spoke subscription
    remoteSubscription: subscription().subscriptionId
    remoteVirtualNetworkGroup:'rg-${environmentType}-${peering.spokeVirtualNetworkGroup}'
    remoteVirtualNetworkName: 'vn-${environmentType}-${peering.spokeVirtualNetworkName}'
  }
  
}]

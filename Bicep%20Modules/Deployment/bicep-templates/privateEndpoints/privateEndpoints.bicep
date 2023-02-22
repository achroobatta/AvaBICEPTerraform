// Params from the *.parameters.json file
param privateEndpointsObject object

// Tagging parameters
param location string
param hubSubscription string
param environmentType string
param deployDate string

// Params from the global.yml VGS
param pepPrefix string
param networkGroup string

module privateEndpointsModule './privateEndpoints.module.bicep' = [for privateEndpoint in privateEndpointsObject.privateEndpoints:{
  // create network with auto created prefix based on location and environment name
  name: privateEndpoint.endpointName
  //always deploy into the network resource group based on location
  scope: resourceGroup(networkGroup)
  params: {
    hubSubscription: hubSubscription
    location: location
    endpointName: '${pepPrefix}${privateEndpoint.endpointName}'
    vnetName: privateEndpoint.vnetName
    subnetName: privateEndpoint.subnetName
    targetResourceName: privateEndpoint.targetResourceName
    targetResourceType: privateEndpoint.targetResourceType
    targetRgName: privateEndpoint.targetRgName
  }
}]

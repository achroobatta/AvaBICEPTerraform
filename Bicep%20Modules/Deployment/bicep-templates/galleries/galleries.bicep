// Params from the loganalytics.as.parameters.json file
param galleryObject object
// Params from the global.yml VGS
param location string
param environmentType string
param deployDate string

resource gallery 'Microsoft.Compute/galleries@2021-10-01' = {
  name: galleryObject.name
  location: location
  tags:{
    Environment: environmentType
    DeployDate: deployDate
    Owner: resourceGroup().tags['Owner']
    CostCentre: resourceGroup().tags['CostCentre']
    Application: resourceGroup().tags['Application']
  }
  properties: {
    description: galleryObject.description
    identifier: {}
    //sharingProfile: {}
    // softDeletePolicy: {
    //   isSoftDeleteEnabled: true
    // }
  }
}

resource imageDefinition 'Microsoft.Compute/galleries/images@2020-09-30' = {
  parent: gallery
  name: galleryObject.imageDefinitionname
  location: location
  properties: {
    osType: galleryObject.imageOsType
    osState: galleryObject.imageOsState
    identifier: {
      publisher: galleryObject.imageDefinitionPublisher
      offer: galleryObject.imageDefinitionOffer
      sku: galleryObject.imageDefinitionSku
    }
    recommended: {
      vCPUs: {
        min: 1
        max: 4
      }
      memory: {
        min: 4
        max: 16
      }
    }
    hyperVGeneration: 'V1'
  }
}

resource imageVersion 'Microsoft.Compute/galleries/images/versions@2021-10-01' = {
  name: galleryObject.imageVersionName
  location: location
  tags:{
    Environment: environmentType
    DeployDate: deployDate
    Owner: resourceGroup().tags['Owner']
    CostCentre: resourceGroup().tags['CostCentre']
    Application: resourceGroup().tags['Application']
  }
  parent: imageDefinition
  properties: {
    publishingProfile: {
      excludeFromLatest: false
      replicaCount: 1
      replicationMode: 'Full'
      storageAccountType: 'Standard_ZRS'
    }
    storageProfile: {
      source: {
        id: galleryObject.id
      }
    }
  }
}

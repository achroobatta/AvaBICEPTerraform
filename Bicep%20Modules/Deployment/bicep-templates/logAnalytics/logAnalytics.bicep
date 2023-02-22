// Params from the loganalytics.as.parameters.json file
param workspaceObject object
// Params from the global.yml VGS
param location string
param wsPrefix string
param environmentType string
param deployDate string
var name = '${wsPrefix}${workspaceObject.name}'

var azureSentinel = {
  name: 'SecurityInsights(${name})'
  galleryName: 'SecurityInsights'
}
var vmInsights = {
  name: 'VMInsights(${name})'
  galleryName: 'VMInsights'
}
var securityCenter = {
  name: 'Security(${name})'
  galleryName: 'Security'
}
var changeTracking = {
  name: 'ChangeTracking(${name})'
  galleryName: 'ChangeTracking'
}

resource name_resource 'Microsoft.OperationalInsights/workspaces@2020-08-01' = {
  name: name
  location: location
  tags: {
    Environment: environmentType
    DeployDate: deployDate
    Owner: resourceGroup().tags['Owner']
    CostCentre: resourceGroup().tags['CostCentre']
    Application: resourceGroup().tags['Application']
  }
  properties: {
    sku: {
      name: workspaceObject.sku
    }
    retentionInDays: workspaceObject.retention
    features: {
      searchVersion: 1
      legacy: 0
      enableLogAccessUsingOnlyResourcePermissions: workspaceObject.resourcePermissions
    }
  }
}

resource solutionsVMInsights 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' =  {
  name: vmInsights.name
  location: location
  properties: {
    workspaceResourceId: name_resource.id
  }
  plan: {
    name: vmInsights.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${vmInsights.galleryName}'
    promotionCode: ''
  }
}

resource solutionsAzureSentinel 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' =  {
  name: azureSentinel.name
  location: location
  properties: {
    workspaceResourceId: name_resource.id
  }
  plan: {
    name: azureSentinel.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${azureSentinel.galleryName}'
    promotionCode: ''
  }
}

resource solutionsSecurityCenter 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' =  {
  name: securityCenter.name
  location: location
  properties: {
    workspaceResourceId: name_resource.id
  }
  plan: {
    name: securityCenter.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${securityCenter.galleryName}'
    promotionCode: ''
  }
}

resource solutionsChangeTracking 'Microsoft.OperationsManagement/solutions@2015-11-01-preview' =  {
  name: changeTracking.name
  location: location
  properties: {
    workspaceResourceId: name_resource.id
  }
  plan: {
    name: changeTracking.name
    publisher: 'Microsoft'
    product: 'OMSGallery/${changeTracking.galleryName}'
    promotionCode: ''
  }
}

output stringOutput string = name_resource.id

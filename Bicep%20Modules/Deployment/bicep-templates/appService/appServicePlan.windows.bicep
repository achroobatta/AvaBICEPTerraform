@description('(required) app service plan name.')
@minLength(2)
param aspName string

@description('(required) Location for all resources.')
param location string = resourceGroup().location

@description('(optional) The SKU of App Service Plan.')
param sku string = 'F1'

param aspPrefix string

var appServicePlanPortalName_var = '${aspPrefix}${aspName}'

resource appServicePlanPortalName 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanPortalName_var
  location: location
  sku: {
    name: sku
  }
}

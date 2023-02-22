@description('(required) Web app name.')
@minLength(2)
param webAppName string

@description('(required) app service plan portal name.')
@minLength(2)
param aspPortalName string

@description('(required) Location for all resources.')
param location string = resourceGroup().location

@description('(optional) The Runtime stack of current web app')
param linuxFxVersion string = 'DOTNETCORE|3.0'

@description('(optional) Git Repo URL')
param repoUrl string = ' '

param asPrefix string
param aspPrefix string

var aspPortalNameId = 'subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/serverfarms/${aspPrefix}${aspPortalName}'
var webApp_var = '${asPrefix}${webAppName}'

resource webAppName_resource 'Microsoft.Web/sites@2021-02-01' = {
  name: webApp_var
  location: location
  properties: {
    httpsOnly: true
    serverFarmId: aspPortalNameId
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      minTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

resource webAppName_web 'Microsoft.Web/sites/sourcecontrols@2021-02-01' = if (contains(repoUrl, 'http')) {
  parent: webAppName_resource
  name: 'web'
  properties: {
    repoUrl: repoUrl
    branch: 'master'
    isManualIntegration: true
  }
}

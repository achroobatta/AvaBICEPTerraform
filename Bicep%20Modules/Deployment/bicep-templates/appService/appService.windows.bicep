@description('(required) Web app name.')
@minLength(2)
param webAppName string

@description('(required) app service plan name.')
@minLength(2)
param aspPortalName string

@description('(required) Location for all resources.')
param location string = resourceGroup().location

@description('(optional) The language stack of the app.')
@allowed([
  '.net'
  'php'
  'node'
  'html'
])
param language string = '.net'

@description('true = deploy a sample Hello World app.')
param helloWorld bool = false

@description('Optional Git Repo URL')
param repoUrl string = ''

param asPrefix string
param aspPrefix string

var aspPortalNameId = 'subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/serverfarms/${aspPrefix}${aspPortalName}'
var webApp_var = '${asPrefix}${webAppName}'

var gitRepoReference = {
  '.net': 'https://github.com/Azure-Samples/app-service-web-dotnet-get-started'
  node: 'https://github.com/Azure-Samples/nodejs-docs-hello-world'
  php: 'https://github.com/Azure-Samples/php-docs-hello-world'
  html: 'https://github.com/Azure-Samples/html-docs-hello-world'
}
var gitRepoUrl = (bool(helloWorld) ? gitRepoReference[toLower(language)] : repoUrl)
var configReference = {
  '.net': {
    comments: '.Net app. No additional configuration needed.'
  }
  html: {
    comments: 'HTML app. No additional configuration needed.'
  }
  php: {
    phpVersion: '7.4'
  }
  node: {
    appSettings: [
      {
        name: 'WEBSITE_NODE_DEFAULT_VERSION'
        value: '12.15.0'
      }
    ]
  }
}

resource webAppName_resource 'Microsoft.Web/sites@2020-06-01' = {
  name: webApp_var
  location: location
  properties: {
    siteConfig: configReference[language]
    serverFarmId: aspPortalNameId
  }
}

resource webAppName_web 'Microsoft.Web/sites/sourcecontrols@2020-06-01' = if (contains(gitRepoUrl, 'http')) {
  parent: webAppName_resource
  name: 'web'
  properties: {
    repoUrl: gitRepoUrl
    branch: 'master'
    isManualIntegration: true
  }
}

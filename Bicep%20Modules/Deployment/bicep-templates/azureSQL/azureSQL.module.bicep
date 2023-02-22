param location string = resourceGroup().location
param sqlServerName string
param databaseNames array
param administratorLogin string
@secure()
param administratorLoginPassword string
param sku object


// Create SQL Server
resource sqlServer 'Microsoft.Sql/servers@2022-02-01-preview' = {
  name: sqlServerName
  location: location
  tags: resourceGroup().tags
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    minimalTlsVersion: '1.2'
    version: '12.0'
    publicNetworkAccess: 'Disabled'
    restrictOutboundNetworkAccess: 'Disabled'
  }
}
// Create Database
resource database 'Microsoft.Sql/servers/databases@2020-08-01-preview' = [for databaseName in databaseNames: if (!empty(databaseNames)) {
  name: '${sqlServer.name}/${empty(databaseNames) ? 'sqldb' : databaseName}'
  location: location
  tags: resourceGroup().tags
  sku: sku
  properties: {
    sourceDatabaseId: sqlServer.id
    autoPauseDelay: 60
    zoneRedundant: false
    maxSizeBytes: 1073741824
  }
}]





param failoverGroupName string
param primarySqlServerName string
param primaryLocation string
param secondarySqlServerName string
param secondaryLocation string
param administratorLogin string
@secure()
param administratorLoginPassword string
param databaseNames array
param sku object
param failover_required bool

module primarySql './azureSQL.module.bicep' = {
  name: 'primarySql'
  params: {
    location: primaryLocation
    databaseNames: databaseNames
    sqlServerName: primarySqlServerName
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    sku:sku
  }
}
module secondarySql './azureSQL.module.bicep' = {
  name: 'secondarySql'
  params: {
    location: secondaryLocation
    sqlServerName: secondarySqlServerName
    databaseNames: []
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    sku: sku
  }
}
resource sqlServerFailoverGroup 'Microsoft.Sql/servers/failoverGroups@2020-11-01-preview' = if (failover_required == true) {
  name: '${primarySqlServerName}/${failoverGroupName}'
  dependsOn: [ primarySql, secondarySql ]
  properties: {
    databases: [for dataBaseName in databaseNames: resourceId('Microsoft.Sql/servers/databases', primarySqlServerName, dataBaseName)]
    readWriteEndpoint: {
      failoverPolicy: 'Automatic'
      failoverWithDataLossGracePeriodMinutes: 60
    }
    readOnlyEndpoint: {
      failoverPolicy: 'Enabled'
    }
    partnerServers: [
      {
        id: resourceId(resourceGroup().name, 'Microsoft.Sql/servers', secondarySqlServerName)
      }
    ]
  }
}

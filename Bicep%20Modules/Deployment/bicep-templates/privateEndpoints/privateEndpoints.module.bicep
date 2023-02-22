@allowed([
  'Application Gateway'
  'App Service'
  'SQL Server'
  'Data Factory'
  'Key Vault'
  'Storage Account'
])
param targetResourceType string
param targetResourceName string
param targetRgName string
param endpointName string
param location string
param subnetName string
param vnetName string
param hubSubscription string

// ONLY REQUIRED FOR STORAGE ACCOUNT
@allowed([
  'blob'
  'blob_secondary'
  'table'
  'table_secondary'
  'queue'
  'queue_secondary'
  'file'
  'file_secondary'
  'web'
  'web_secondary'
  'dfs'
  'dfs_secondary'
])
param storageSubresource string = 'blob'

var vnetId = '/subscriptions/${hubSubscription}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Network/virtualNetworks/${vnetName}'
var subnetId = '${vnetId}/subnets/${subnetName}'
var sqlId = ((targetResourceType == 'SQL Server') ? '/subscriptions/${hubSubscription}/resourceGroups/${targetRgName}/providers/Microsoft.Sql/servers/${targetResourceName}' : json('null'))
var kvId = ((targetResourceType == 'Key Vault') ? '/subscriptions/${hubSubscription}/resourceGroups/${targetRgName}/providers/Microsoft.KeyVault/vaults/${targetResourceName}' : json('null'))
var applicationGatewayId = ((targetResourceType == 'Application Gateway') ? '/subscriptions/${hubSubscription}/resourceGroups/${targetRgName}/providers/Microsoft.Network/applicationgateways/${targetResourceName}' : json('null'))
var dataFactoryId = ((targetResourceType == 'Data Factory') ? '/subscriptions/${hubSubscription}/resourceGroups/${targetRgName}/providers/Microsoft.DataFactory/factories/${targetResourceName}' : json('null'))
var appServiceId = ((targetResourceType == 'App Service') ? '/subscriptions/${hubSubscription}/resourceGroups/${targetRgName}/providers/Microsoft.Web/sites/${targetResourceName}' : json('null'))
var storageAccountId = ((targetResourceType == 'Storage Account') ? '/subscriptions/${hubSubscription}/resourceGroups/${targetRgName}/providers/Microsoft.Storage/storageAccounts/${targetResourceName}' : json('null'))

resource sqlserver 'Microsoft.Network/privateEndpoints@2020-03-01' = if (targetResourceType == 'SQL Server') {
  location: location
  name: '${endpointName}-sql'
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        type: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections'
        name: endpointName
        properties: {
          privateLinkServiceId: sqlId
          groupIds: [
            'sqlServer'
          ]
        }
      }
    ]
  }
  tags: {
  }
}

resource kv 'Microsoft.Network/privateEndpoints@2020-03-01' = if (targetResourceType == 'Key Vault') {
  location: location
  name: '${endpointName}-kv'
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        type: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections'
        name: endpointName
        properties: {
          privateLinkServiceId: kvId
          groupIds: [
            'vault'
          ]
        }
      }
    ]
  }
  tags: {
  }
}

resource ag 'Microsoft.Network/privateEndpoints@2020-03-01' = if (targetResourceType == 'Application Gateway') {
  location: location
  name: '${endpointName}-ag'
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        type: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections'
        name: endpointName
        properties: {
          privateLinkServiceId: applicationGatewayId
          groupIds: [
            'application gateway'
          ]
        }
      }
    ]
  }
  tags: {
  }
}

resource df 'Microsoft.Network/privateEndpoints@2020-03-01' = if (targetResourceType == 'Data Factory') {
  location: location
  name: '${endpointName}-df'
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        type: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections'
        name: endpointName
        properties: {
          privateLinkServiceId: dataFactoryId
          groupIds: [
            'dataFactory'
          ]
        }
      }
    ]
  }
  tags: {
  }
}

resource as 'Microsoft.Network/privateEndpoints@2020-03-01' = if (targetResourceType == 'App Service') {
  location: location
  name: '${endpointName}-as'
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        type: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections'
        name: endpointName
        properties: {
          privateLinkServiceId: appServiceId
          groupIds: [
            'sites'
          ]
        }
      }
    ]
  }
  tags: {
  }
}

resource sa 'Microsoft.Network/privateEndpoints@2020-03-01' = if (targetResourceType == 'Storage Account') {
  location: location
  name: '${endpointName}-sa'
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        type: 'Microsoft.Network/privateEndpoints/privateLinkServiceConnections'
        name: endpointName
        properties: {
          privateLinkServiceId: storageAccountId
          groupIds: [
            storageSubresource
          ]
        }
      }
    ]
  }
  tags: {
  }
}

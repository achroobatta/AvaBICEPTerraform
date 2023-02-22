targetScope = 'resourceGroup'
// Params from the *.parameters.json file
param keyVaultObject object

param tags object
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string
param name string
param location string
var password = 'X${uniqueString(resourceGroup().id)}@'
var tenantId = tenant().tenantId

// Existing resources required
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' = {
  name: name
  location: location
  tags: tags
  properties: {
    createMode: 'default'
    enabledForDeployment: true
    enabledForDiskEncryption: true
    enabledForTemplateDeployment: true
    enablePurgeProtection: true
    enableRbacAuthorization: true
    enableSoftDelete: true
    networkAcls: contains(keyVaultObject,'networkAcls')? {
      bypass: 'string'
      defaultAction: 'string'
      ipRules: [
        {
          value: 'string'
        }
      ]
      virtualNetworkRules: [
        {
          id: 'string'
          ignoreMissingVnetServiceEndpoint: true
        }
      ]
    } : null
    publicNetworkAccess: keyVaultObject.publicNetworkAccess
    sku: {
      family: 'A'
      name: keyVaultObject.sku
    }
    softDeleteRetentionInDays: keyVaultObject.softDeleteRetentionInDays
    tenantId: tenantId
  }
}

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  scope: keyVault
  properties: {
    logAnalyticsDestinationType: null
    logs: [
      {
        categoryGroup: 'allLogs'
        enabled: true
        retentionPolicy: {
          days: 60
          enabled: true
        }
      }
      {
        categoryGroup: 'audit'
        enabled: true
        retentionPolicy: {
          days: 60
          enabled: true
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 60
          enabled: true
        }
      }
    ]
    storageAccountId: storageAccount.id
    workspaceId: logAnalytics.id
  }
}
// only create admin and password in keyvaults tagged as "vmPasswordSafe" in the parameter file
resource adminPassword 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = if (keyVaultObject.vmPasswordSafe) {
  name: 'adminPassword'
  parent: keyVault
  properties: {
    contentType: 'string'
    value: password
  }
}

resource adminUserName 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' = if (keyVaultObject.vmPasswordSafe) {
  name: 'adminUserName'
  parent: keyVault
  properties: {
    contentType: 'string'
    value: 'avanoso_admin'
  }
}

// To determine role ids use Get-AzRoleDefinition -Name "Key Vault Administrator"
// resource keyvaultAdministrator 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
//   scope: subscription()
//   name: '00482a5a-887f-4fb3-b363-3b7fe8e74483'
// }
// Additional permissions required for the Enterprise app - needs to be User Access Administrator or Owner to set permissions
// resource keyvaultAdminRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(resourceGroup().id, keyVaultObject.keyvaultAdministrator, keyvaultAdministrator.id)
//   scope: keyVault
//   properties: {
//     roleDefinitionId: keyvaultAdministrator.id
//     principalId: keyVaultObject.keyvaultAdministrator
//     principalType: 'Group'
//   }
// }
// To determine role ids use Get-AzRoleDefinition -Name "Key Vault Reader"
// resource keyvaultReader 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
//   scope: subscription()
//   name: '4633458b-17de-408a-b874-0445c86b69e6'
// }
// Additional permissions required for the Enterprise app - needs to be User Access Administrator or Owner to set permissions
// resource keyvaultReaderRoleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(resourceGroup().id, keyVaultObject.keyvaultReader, keyvaultReader.id)
//   scope: keyVault
//   properties: {
//     roleDefinitionId: keyvaultReader.id
//     principalId: keyVaultObject.keyvaultReader
//     principalType: 'Group'
//   }
// }

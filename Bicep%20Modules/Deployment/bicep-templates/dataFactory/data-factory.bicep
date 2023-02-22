// Data Factory with Private Endpoint

///////////////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
//////////////////////////////////////////////////////////////////////////////////////
param location string 
param dataFactoryName string
param datafactoryPrivateEndpointName string
param vNetResourceGroupName string
param virtualNetworkName string
param subnetName string
param resourceTags object
param diagnostics object
param privateDNSZone object

///////////////////////////////////////////////////////////////////////////////////////
// Variable Definitions
//////////////////////////////////////////////////////////////////////////////////////

// Diag and Nic Names
var dataFactoryNeworkInterfaceName = '${datafactoryPrivateEndpointName}-nic'
var dataFactoryNeworkInterfaceDiagnosticSettingsName = '${dataFactoryNeworkInterfaceName}-diag'
var dataFactoryDiagnosticSettingsName = '${dataFactoryName}-diag'

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions
//////////////////////////////////////////////////////////////////////////////////////

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  tags: resourceTags
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Disabled'
  }
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for Private Endpoint and Private DNS
//////////////////////////////////////////////////////////////////////////////////////

resource datafactoryPrivateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  location: location
  name: datafactoryPrivateEndpointName
  tags: resourceTags
  properties: {
    subnet: {
      id: resourceId(vNetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
    }
    customNetworkInterfaceName: dataFactoryNeworkInterfaceName
    privateLinkServiceConnections: [
      {
        name: datafactoryPrivateEndpointName
        properties: {
          privateLinkServiceId: dataFactory.id
          groupIds: [
            'dataFactory'
          ]
        }
      }
    ]
  }
}

resource datafactoryPrivateDNSZoneGroup 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-03-01' = {
  parent: datafactoryPrivateEndpoint
  name: 'default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink.datafactory.azure.net'
        properties: {
          privateDnsZoneId: resourceId(privateDNSZone.subscription, privateDNSZone.resourceGroup, 'Microsoft.Network/privateDnsZones', 'privatelink.datafactory.azure.net')
        }
      }
    ]
  }
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for Diagnostic Settings
//////////////////////////////////////////////////////////////////////////////////////

resource dataFactoryDiagSettings 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: dataFactoryDiagnosticSettingsName
  scope: dataFactory
  properties: {
    workspaceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces', diagnostics.workspaceName)
    storageAccountId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.Storage/storageAccounts', diagnostics.storageAccount)
    logs: [
      {
        category: 'ActivityRuns'
        enabled: true
      }
      {
        category: 'PipelineRuns'
        enabled: true
      }
      {
        category: 'TriggerRuns'
        enabled: true
      }
      {
        category: 'SandboxPipelineRuns'
        enabled: true
      }
      {
        category: 'SandboxActivityRuns'
        enabled: true
      }
      {
        category: 'SSISPackageEventMessages'
        enabled: true
      }
      {
        category: 'SSISPackageExecutableStatistics'
        enabled: true
      }
      {
        category: 'SSISPackageEventMessageContext'
        enabled: true
      }
      {
        category: 'SSISPackageExecutionComponentPhases'
        enabled: true
      }
      {
        category: 'SSISPackageExecutionDataStatistics'
        enabled: true
      }
      {
        category: 'SSISIntegrationRuntimeLogs'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
  dependsOn: [
    datafactoryPrivateEndpoint
  ]
}

resource NIC 'Microsoft.Network/networkInterfaces@2022-01-01' existing = {
  name: dataFactoryNeworkInterfaceName
}

resource dataFactoryNeworkInterfaceDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {  
name: dataFactoryNeworkInterfaceDiagnosticSettingsName
scope: NIC
properties: {
    workspaceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces', diagnostics.workspaceName)
    storageAccountId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.Storage/storageAccounts', diagnostics.storageAccount)
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
  dependsOn: [
    datafactoryPrivateEndpoint
  ]
}

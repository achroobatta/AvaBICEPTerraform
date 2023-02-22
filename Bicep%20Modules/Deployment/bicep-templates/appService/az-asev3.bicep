// ASEv3 Deployment with App Service, App Service Plan, App Insights and Diagnostics

///////////////////////////////////////////////////////////////////////////////////////
// Parameter Definitions
//////////////////////////////////////////////////////////////////////////////////////

//Specifies the location for all resources
@description('Required. Location for all resources.')
param location string = resourceGroup().location

// Resource Group name of virtual network 
@description('Required. Resource Group name of virtual network if using existing vnet and subnet.')
param vNetResourceGroupName string

//Specifies the diagnostics and aseDiagSettingName
param diagnostics object = {
  subscription: 'b2aa4b62-e79e-4022-b232-257f089ec323'
  resourceGroup: 'de-plat-mgmt-logag-auea-rg'
  workspaceName: 'de-aec-log'
  storageAccount: 'deaueastlogmgmt01'
}
param aseDiagSettingName string

// Uses existing virtual network and subnet.
@description('Required. Use existing virtual network and subnet.')
param useExistingVnetandSubnet bool = true
// The name of virtual network 
@description('Required. The Virtual Network (vNet) Name.')
param virtualNetworkName string
@description('Required. An Array of 1 or more IP Address Prefixes for the Virtual Network.')
param virtualNetworkAddressSpace string
@description('Required. The subnet Name of ASEv3.')
param subnetAddressSpace string
@description('Required. The subnet Name of ASEv3.')
param subnetName string
@description('Required. The subnet properties.')
param subnets array = [
  {
    name: subnetName
    addressPrefix: subnetAddressSpace
    delegations: [
      {
        name: 'Microsoft.Web.hostingEnvironments'
        properties: {
          serviceName: 'Microsoft.Web/hostingEnvironments'
        }
      }
    ]
    privateEndpointNetworkPolicies: 'Enabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
]

//Specifies the App Service and webAppDiagSettingName
@description('Web app name.')
@minLength(2)
param webAppName string = 'app-${uniqueString(resourceGroup().id)}'
@description('description')
param webAppDiagSettingName string

//Specifies the App Insight and AppInsightDiagSettingName
@description('App Insight Name')
param AppInsightName string
@description('description')
param AppInsightDiagSettingName string

//Specifies the requestSource and Type
@description('Source of Azure Resource Manager deployment')
param requestSource string
@description('Type of app you are deploying. This field is for legacy reasons and will not impact the type of App Insights resource you deploy.')
param type string

//Specifies the resourceTags
param resourceTags object = {
  Project: ''
  Stream: 'EAI'
  Zone: 'Corp'
  Environment: 'ST - System Test'
}

//Specifies the sku and skuCode
param sku string
param skuCode string

//Specifies the name of the App Service plan to use for hosting the web app and the appServicePlanDiagSettingName
@description('The name of the App Service plan to use for hosting the web app.')
param appServicePlanName string = 'plan-${uniqueString(resourceGroup().id)}'
@description('description')
param appServicePlanDiagSettingName string

//Specifies the name and related settings for ASEv3 
@description('Required. Name of ASEv3.')
param aseName string = 'ase-${uniqueString(resourceGroup().id)}'
@description('Required. Dedicated host count of ASEv3.')
param dedicatedHostCount string = '0'
@description('Required. Zone redundant of ASEv3.')
param zoneRedundant bool = false
param currentStack string
param phpVersion string
param netFrameworkVersion string
param alwaysOn bool
param workerSize string
param workerSizeId string
param numberOfWorkers string
@description('Required. Load balancer mode: 0-external load balancer, 3-internal load balancer for ASEv3.')
@allowed([
  0
  3
])
param internalLoadBalancingMode int = 3

///////////////////////////////////////////////////////////////////////////////////////
// Variable Definitions
//////////////////////////////////////////////////////////////////////////////////////

var uniStr = uniqueString(resourceGroup().id)
var subnetId = resourceId(vNetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for ASEv3
//////////////////////////////////////////////////////////////////////////////////////

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2020-11-01' = if (!useExistingVnetandSubnet) {
  name: virtualNetworkName
  location: location
  properties: {
    subnets: [for item in subnets: {
      name: item.name
      properties: {
        addressPrefix: item.addressPrefix
        delegations: item.delegations
      }
    }]
    addressSpace: {
      addressPrefixes: virtualNetworkAddressSpace
    }
  }
  dependsOn: []
}

resource aseName_resource 'Microsoft.Web/hostingEnvironments@2021-03-01' = {
  name: aseName
  tags: resourceTags
  location: location
  kind: 'ASEV3'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dedicatedHostCount: dedicatedHostCount
    zoneRedundant: zoneRedundant
    internalLoadBalancingMode: internalLoadBalancingMode
    clusterSettings: [
      {
        name: 'DisableTls1.0'
        value: '1'
      }
    ]
    virtualNetwork: {
      id: subnetId
    }
  }
  dependsOn: [
    virtualNetworkName_resource
  ]
}

module subnetName_subnet_delegation_uniStr './subnetNameDelegation.bicep' = if (useExistingVnetandSubnet) {
  name: '${subnetName}-subnet-delegation-${uniStr}'
  scope: resourceGroup(vNetResourceGroupName)
  params: {
    virtualNetworkName: virtualNetworkName
    subnetName: subnetName
    subnetAddressSpace: subnetAddressSpace
  }
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for ASEv3 Diagnostic Settings
//////////////////////////////////////////////////////////////////////////////////////

resource aseDiagSetting 'Microsoft.Web/hostingEnvironments/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${aseName}/Microsoft.Insights/${aseDiagSettingName}'
  location: location
  properties: {
    workspaceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces/', diagnostics.workspaceName)
    storageAccountId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.Storage/storageAccounts', diagnostics.storageAccount)
    logs: [
      {
        category: 'AppServiceEnvironmentPlatformLogs'
        enabled: true
      }
    ]
  }
  dependsOn: [
    aseName_resource
    AppInsightName_resource
  ]
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for App Service
//////////////////////////////////////////////////////////////////////////////////////

resource webAppName_resource 'Microsoft.Web/sites@2021-03-01' = {
  name: webAppName
  location: location
  tags: resourceTags
  kind: 'app'
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    name: webAppName
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: AppInsightName_resource.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: AppInsightName_resource.properties.ConnectionString
        }
        {
          name: 'ApplicationInsightsAgent_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'XDT_MicrosoftApplicationInsights_Mode'
          value: 'default'
        }
        {
          name: 'DiagnosticServices_EXTENSION_VERSION'
          value: '~3'
        }
        {
          name: 'InstrumentationEngine_EXTENSION_VERSION'
          value: '~1'
        }
      ]
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: currentStack
        }
      ]
      phpVersion: phpVersion
      netFrameworkVersion: netFrameworkVersion
      alwaysOn: alwaysOn
      http20Enabled: true
      ftpsState: 'Disabled'
      minTlsVersion: '1.2'
    }
    serverFarmId: appServicePlanName_resource.id
    httpsOnly: true
    hostingEnvironmentProfile: {
      id: aseName_resource.id
    }
    resources: [
      {
        type: 'sourcecontrols'
        name: 'web'
        apiVersion: '2021-03-01'
        properties: {
          gitHubActionConfiguration: {
            generateWorkflowFile: false
          }
        }
      }
    ]
  }
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for App Service Diagnostic Settings  
//////////////////////////////////////////////////////////////////////////////////////

resource webAppDiagSetting 'Microsoft.Web/sites/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${webAppName}/Microsoft.Insights/${webAppDiagSettingName}'
  location: location
  properties: {
    workspaceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces/', diagnostics.workspaceName)
    storageAccountId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.Storage/storageAccounts', diagnostics.storageAccount)
    logs: [
      {
        category: 'AppServiceHTTPLogs'
        enabled: true
      }
      {
        category: 'AppServiceConsoleLogs'
        enabled: true
      }
      {
        category: 'AppServiceAppLogs'
        enabled: true
      }
      {
        category: 'AppServiceAuditLogs'
        enabled: true
      }
      {
        category: 'AppServiceIPSecAuditLogs'
        enabled: true
      }
      {
        category: 'AppServicePlatformLogs'
        enabled: true
      }
      {
        category: 'AppServiceAntivirusScanAuditLogs'
        enabled: true
      }
      {
        category: 'AppServiceFileAuditLogs'
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
    webAppName_resource
    appServicePlanName_resource
    AppInsightName_resource
  ]
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for App Insights
//////////////////////////////////////////////////////////////////////////////////////

resource AppInsightName_resource 'microsoft.insights/components@2020-02-02' = {
  name: AppInsightName
  location: location
  kind: 'web'
  tags: resourceTags
  properties: {
    ApplicationId: AppInsightName
    Application_Type: type
    Flow_Type: 'Bluefield'
    Request_Source: requestSource
    WorkspaceResourceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces/', diagnostics.workspaceName)
  }
  dependsOn: []
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for App Insights Diagnostic Settings 
//////////////////////////////////////////////////////////////////////////////////////

resource AppInsightDiagSetting 'microsoft.insights/components/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${AppInsightName}/Microsoft.Insights/${AppInsightDiagSettingName}'
  location: location
  properties: {
    logs: [
      {
        category: 'AppAvailabilityResults'
        enabled: true
      }
      {
        category: 'AppBrowserTimings'
        enabled: true
      }
      {
        category: 'AppEvents'
        enabled: true
      }
      {
        category: 'AppMetrics'
        enabled: true
      }
      {
        category: 'AppDependencies'
        enabled: true
      }
      {
        category: 'AppExceptions'
        enabled: true
      }
      {
        category: 'AppPageViews'
        enabled: true
      }
      {
        category: 'AppPerformanceCounters'
        enabled: true
      }
      {
        category: 'AppRequests'
        enabled: true
      }
      {
        category: 'AppSystemEvents'
        enabled: true
      }
      {
        category: 'AppTraces'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
    workspaceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces/', diagnostics.workspaceName)
    storageAccountId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.Storage/storageAccounts', diagnostics.storageAccount)
  }
  dependsOn: [
    AppInsightName_resource
  ]
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for App Service Plan
//////////////////////////////////////////////////////////////////////////////////////

resource appServicePlanName_resource 'Microsoft.Web/serverfarms@2021-03-01' = {
  name: appServicePlanName
  tags: resourceTags
  location: location
  properties: {
    name: appServicePlanName
    workerSize: workerSize
    workerSizeId: workerSizeId
    numberOfWorkers: numberOfWorkers
    hostingEnvironmentProfile: {
      id: aseName_resource.id
      zoneRedundant: true
    }
  }
  sku: {
    tier: sku
    name: skuCode
  }
}

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions for App Service Plan Diagnostic Settings 
//////////////////////////////////////////////////////////////////////////////////////

resource appServicePlanDiagSetting 'Microsoft.Web/serverfarms/providers/diagnosticSettings@2017-05-01-preview' = {
  name: '${appServicePlanName}/Microsoft.Insights/${appServicePlanDiagSettingName}'
  location: location
  properties: {
    workspaceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces/', diagnostics.workspaceName)
    storageAccountId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.Storage/storageAccounts', diagnostics.storageAccount)
    logs: []
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
  dependsOn: [
    appServicePlanName_resource
    aseName_resource
    AppInsightName_resource
    webAppName_resource
  ]
}

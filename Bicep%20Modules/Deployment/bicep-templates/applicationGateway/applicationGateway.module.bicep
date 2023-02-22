@description('Application gateway name')
param appGatewayName string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Tags for Applications gateway')
param tags object = resourceGroup().tags

@description('Application gateway tier')
@allowed([
  'Standard'
  'WAF'
  'Standard_v2'
  'WAF_v2'
])
param appGatewayTier string

@description('Application gateway sku')
@allowed([
  'Standard_Small'
  'Standard_Medium'
  'Standard_Large'
  'WAF_Medium'
  'WAF_Large'
  'Standard_v2'
  'WAF_v2'
])
param appGatewaySKU string

@description('Enable HTTP/2 support')
param http2Enabled bool = true

@description('Capacity (instance count) of application gateway')
@minValue(1)
@maxValue(32)
param capacity int = 2

@description('Autoscale capacity (instance count) of application gateway')
@minValue(1)
@maxValue(32)
param autoScaleMaxCapacity int = 10

@description('Enable Azure availabilty zone redundancy')
param zoneRedundant bool = false

@description('Public ip address name')
param publicIpAddressName string = 'pip-${appGatewayName}'

@description('Virutal network subscription id')
param vNetSubscriptionId string = subscription().subscriptionId

@description('Virutal network resource group')
param vNetResourceGroup string

@description('Virutal network name')
param vNetName string

@description('Application gateway subnet name')
param subnetName string

@description('Array containing http listeners')
@metadata({
  name: 'Listener name'
  protocol: 'Listener protocol'
  frontEndPort: 'Front end port name'
  sslCertificate: 'SSL certificate name' // only required for https listeners
  hostNames: 'Array containing host names'
  firewallPolicy: 'Enabled/Disabled. Configures firewall policy on listener'
})
param httpListeners array

@description('Array containing backend address pools')
@metadata({
  name: 'Backend address pool name'
  backendAddresses: 'Array containing backend addresses'
})
param backendAddressPools array = []

@description('Array containing backend http settings')
@metadata({
  name: 'Backend http setting name'
  port: 'integer containing port number'
  protocol: 'Backend http setting protocol'
  cookieBasedAffinity: 'Enabled/Disabled. Configures cookie based affinity.'
  requestTimeout: 'Integer containing backend http setting request timeout'
  connectionDraining: {
    drainTimeoutInSec: 'Integer containing connection drain timeout in seconds'
    enabled: 'Bool to enable connection draining'
  }
  trustedRootCertificate: 'Trusted root certificate name'
  hostName: 'Backend http setting host name'
  probeName: 'Custom probe name'
})
param backendHttpSettings array = []

@description('Array containing request routing rules')
@metadata({
  name: 'Rule name'
  ruleType: 'Rule type'
  listener: 'Http listener name'
  backendPool: 'Backend pool name'
  backendHttpSettings: 'Backend http setting name'
  redirectConfiguration: 'Redirection configuration name'
})
param requestRoutingRules array

@description('Array containing redirect configurations')
@metadata({
  name: 'Redirecton name'
  redirectType: 'Redirect type'
  targetUrl: 'Target URL'
  includePath: 'Bool to include path'
  includeQueryString: 'Bool to include query string'
  requestRoutingRule: 'Name of request routing rule to associate redirection configuration'
})
param redirectConfigurations array = []

@description('Array containing front end ports')
@metadata({
  name: 'Front port name'
  port: 'Integer containing port number'
})
param frontEndPorts array

@description('Array containing custom probes')
@metadata({
  name: 'Custom probe name'
  protocol: 'Custom probe protocol'
  host: 'Host name'
  path: 'Probe path'
  interval: 'Integer containing probe interval'
  timeout: 'Integer containing probe timeout'
  unhealthyThreshold: 'Integer containing probe unhealthy threshold'
  pickHostNameFromBackendHttpSettings: 'Bool to enable pick host name from backend settings'
  minServers: 'Integer containing min servers'
  match: {
    statusCodes: [
      'Custom probe status codes'
    ]
  }
})
param customProbes array = []

@description('Application Gateway Global Configuration')
@metadata({
    enableRequestBuffering: 'true or false' //bool
    enableResponseBuffering: 'true or false' //bool
  }
)
param globalConfiguration object = {}

@description('Resource id of an existing user assigned managed identity to associate with the application gateway')
param managedIdentityResourceId string = ''

@description('Enable web application firewall')
param enableWebApplicationFirewall bool = false

@description('Name of the firewall policy. Only required if enableWebApplicationFirewall is set to true')
param firewallPolicyName string = ''

@description('Array containing the firewall policy settings. Only required if enableWebApplicationFirewall is set to true')
@metadata({
  requestBodyCheck: 'Bool to enable request body check'
  maxRequestBodySizeInKb: 'Integer containing max request body size in kb'
  fileUploadLimitInMb: 'Integer containing file upload limit in mb'
  state: 'Enabled/Disabled. Configures firewall policy settings'
  mode: 'Sets the detection mode'
})
param firewallPolicySettings object = {
  requestBodyCheck: true
  maxRequestBodySizeInKb: 128
  fileUploadLimitInMb: 100
  state: 'Enabled'
  mode: 'Detection'
}

@description('If true, associates a firewall policy with an application gateway regardless whether the policy differs from the WAF Config.')
param forceFirewallPolicyAssociation bool = false

@description('Array containing the firewall policy custom rules. Only required if enableWebApplicationFirewall is set to true')
@metadata({
  action: 'Type of actions'
  matchConditions: 'Array containing match conditions'
  name: 'Custom rule name'
  priority: 'Integer containing priority'
  ruleType: 'Rule type'
})
param firewallPolicyCustomRules array = []

@description('Array containing the firewall policy managed rule sets. Only required if enableWebApplicationFirewall is set to true')
@metadata({
  ruleSetType: 'Rule set type'
  ruleSetVersion: 'Rule set version'
})
param firewallPolicyManagedRuleSets array = [
  {
    ruleSetType: 'OWASP'
    ruleSetVersion: '3.2'
  }
]

@description('Array containing the firewall policy managed rule exclusions. Only required if enableWebApplicationFirewall is set to true')
@metadata({
  matchVariable: 'Variable to be excluded'
  selector: 'String specifying exclusions'
  selectorMatchOperator: 'Exclusion operator'
})
param firewallPolicyManagedRuleExclusions array = []

@description('Enable delete lock')
param enableDeleteLock bool = false

@description('Enable diagnostic logs')
param enableDiagnostics bool = false

var appGatewayLockName = '${applicationGateway.name}-lck'
var appGatewayDiagnosticsName = '${applicationGateway.name}-dgs'
var gatewayIpConfigurationName = 'appGatewayIpConfig'
var frontendIpConfigurationName = 'appGwPublicFrontendIp'

param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}

resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2021-05-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name: 'Standard'
  }
  zones: zoneRedundant ? [
    '1'
    '2'
    '3'
  ] : []
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-08-01' = {
  name: appGatewayName
  location: location
  tags: tags
  zones: zoneRedundant ? [
    '1'
    '2'
    '3'
  ] : []
  identity: !empty(managedIdentityResourceId) ? {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${managedIdentityResourceId}': {}
    }
  } : null
  properties: {
    autoscaleConfiguration: {
      minCapacity: capacity
      maxCapacity: autoScaleMaxCapacity
    }
    sku: {
      name: appGatewaySKU
      tier: appGatewayTier
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIpConfigurationName
        properties: {
          subnet: {
            id: resourceId(vNetSubscriptionId, vNetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vNetName, subnetName)
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendIpConfigurationName
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddress.id
          }
        }
      }
    ]
    frontendPorts: [for frontEndPort in frontEndPorts: {
      name: frontEndPort.name
      properties: {
        port: frontEndPort.port
      }
    }]
    backendAddressPools: [for backendAddressPool in backendAddressPools: {
      name: backendAddressPool.name
      properties: {
        backendAddresses: backendAddressPool.backendAddresses
      }
    }]
    backendHttpSettingsCollection: [for backendHttpSetting in backendHttpSettings: {
      name: backendHttpSetting.name
      properties: {
        affinityCookieName: contains(backendHttpSetting, 'affinityCookieName') ? backendHttpSetting.affinityCookieName : null
        connectionDraining: backendHttpSetting.connectionDraining
        cookieBasedAffinity: backendHttpSetting.cookieBasedAffinity
        hostName: contains(backendHttpSetting, 'hostName') ? backendHttpSetting.hostName : null
        pickHostNameFromBackendAddress: contains(backendHttpSetting, 'pickHostNameFromBackendAddress') ? backendHttpSetting.pickHostNameFromBackendAddress : false
        port: backendHttpSetting.port
        probe: contains(backendHttpSetting, 'probeName') ? {
          id: resourceId('Microsoft.Network/applicationGateways/probes', appGatewayName, backendHttpSetting.probeName)
        }: null
        probeEnabled: contains(backendHttpSetting, 'probeName') ? true : false
        protocol: backendHttpSetting.protocol
        requestTimeout: backendHttpSetting.requestTimeout
        trustedRootCertificates: contains(backendHttpSetting, 'trustedRootCertificate') ? [{
          id: resourceId('Microsoft.Network/applicationGateways/trustedRootCertificates', appGatewayName, backendHttpSetting.trustedRootCertificate)
        }]: null
      }
    }]
    globalConfiguration: (globalConfiguration != null) ? globalConfiguration : {}
    httpListeners: [for httpListener in httpListeners: {
      name: httpListener.name
      properties: {
        frontendIPConfiguration: {
          id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', appGatewayName, frontendIpConfigurationName)
        }
        frontendPort: {
          id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', appGatewayName, httpListener.frontEndPort)
        }
        protocol: httpListener.protocol
        hostNames: contains(httpListener, 'hostNames') ? httpListener.hostNames : null
        hostName: contains(httpListener, 'hostName') ? httpListener.hostName : null
        requireServerNameIndication: contains(httpListener, 'requireServerNameIndication') ? httpListener.requireServerNameIndication : false
        firewallPolicy: contains(httpListener, 'firewallPolicy') ? {
          id: firewallPolicy.id
        } : null
      }
    }]
    redirectConfigurations: [for redirectConfiguration in redirectConfigurations: {
      name: redirectConfiguration.name
      properties: {
        redirectType: redirectConfiguration.redirectType
        targetUrl: redirectConfiguration.targetUrl
        targetListener: contains(redirectConfiguration, 'targetListener') ? {
         id:  resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, redirectConfiguration.targetListener)
        }: null
        includePath: redirectConfiguration.includePath
        includeQueryString: redirectConfiguration.includeQueryString
        requestRoutingRules: [
          {
            id: resourceId('Microsoft.Network/applicationGateways/requestRoutingRules', appGatewayName, redirectConfiguration.requestRoutingRule)
          }
        ]
      }
    }]
    requestRoutingRules: [for rule in requestRoutingRules: {
      name: rule.name
      properties: {
        ruleType: rule.ruleType
        priority: rule.priority
        httpListener: contains(rule, 'listener') ? {
          id: resourceId('Microsoft.Network/applicationGateways/httpListeners', appGatewayName, rule.listener)
        } : null
        backendAddressPool: contains(rule, 'backendPool') ? {
          id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', appGatewayName, rule.backendPool)
        } : null
        backendHttpSettings: contains(rule, 'backendHttpSettings') ? {
          id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', appGatewayName, rule.backendHttpSettings)
        } : null
        redirectConfiguration: contains(rule, 'redirectConfiguration') ? {
          id: resourceId('Microsoft.Network/applicationGateways/redirectConfigurations', appGatewayName, rule.redirectConfiguration)
        } : null
      }
    }]
    enableHttp2: http2Enabled
    webApplicationFirewallConfiguration: enableWebApplicationFirewall ? {
      enabled: firewallPolicySettings.state == 'Enabled' ? true : false
      firewallMode: firewallPolicySettings.mode
      ruleSetType: 'OWASP'
      ruleSetVersion: '3.2'
      requestBodyCheck: true
      maxRequestBodySizeInKb: 128
      fileUploadLimitInMb: 100
    } : null

    firewallPolicy: enableWebApplicationFirewall ? {
      id: firewallPolicy.id
    } : null
    forceFirewallPolicyAssociation:  forceFirewallPolicyAssociation
    probes: [for probe in customProbes: {
      name: probe.name
      properties: {
        protocol: probe.protocol
        host: probe.host
        path: probe.path
        interval: probe.interval
        timeout: probe.timeout
        unhealthyThreshold: probe.unhealthyThreshold
        pickHostNameFromBackendHttpSettings: probe.pickHostNameFromBackendHttpSettings
        minServers: probe.minServers
        match: probe.match
      }
    }]
  }
  dependsOn: [

  ]
}

resource firewallPolicy 'Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies@2021-08-01' = if (enableWebApplicationFirewall) {
  name: firewallPolicyName == '' ? 'placeholdervalue' : firewallPolicyName // placeholder value required as name cannot be empty/null when enableWebApplicationFirewall equals false 
  location: location
  properties: {
    customRules: firewallPolicyCustomRules
    policySettings: firewallPolicySettings
    managedRules: {
      managedRuleSets: firewallPolicyManagedRuleSets
      exclusions: firewallPolicyManagedRuleExclusions
    }
  }
}

resource applicationGatewayDiagnostics 'microsoft.insights/diagnosticSettings@2021-05-01-preview' = if (enableDiagnostics) {
  scope: applicationGateway
  name: appGatewayDiagnosticsName
  properties: {
    storageAccountId: storageAccount.id
    workspaceId: logAnalytics.id
    logs: [
      {
        category: 'ApplicationGatewayAccessLog'
        enabled: true
      }
      {
        category: 'ApplicationGatewayPerformanceLog'
        enabled: true
      }
      {
        category: 'ApplicationGatewayFirewallLog'
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
}


resource applicationGatewayLock 'Microsoft.Authorization/locks@2017-04-01' = if (enableDeleteLock) {
  scope: applicationGateway
  name: appGatewayLockName
  properties: {
    level: 'CanNotDelete'
  }
}

output name string = applicationGateway.name
output id string = applicationGateway.id
output publicIpAddress string =  publicIpAddress.properties.publicIPAllocationMethod == 'Static' ? publicIpAddress.properties.ipAddress : ''

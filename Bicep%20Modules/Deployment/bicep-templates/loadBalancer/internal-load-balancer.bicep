@description('vNet for the Load Balancer')
param virtualNetworkName string

@description('Resouce group containing the vNet')
param vNetResourceGroupName string

@description('Subnet for the Load Balancer.')
param subnetName string

@description('Subnet for the Virtual Machine.')
param loadBalancerName string

@description('Stock Keeping Unit for LB')
param loadBalancerSKU string = 'Standard'

@description('SKU Tier for the LB')
param loadBalancerTier string = 'Regional'

@description('Load Balancer Frontend Configuration Name')
param loadBalancerFrontEndIPConfigName string = 'LoadBalancerFrontend'

@description('Load Balancer Frontend IPv4 Configuration, default to null and assign a Dyanamic IP')
param loadBalancerFrontEndIP string = 'null'

@description('Load Balancer Backend Pool Configuration Name')
param loadBalancerBackEndPoolName string

@description('Load Balancer Backend Pool VMs to add')
param loadBalancerBackendVMs array
param loadBalancerInboundNatPool bool = false
param loadBalancerInboundNatPools object = {
  name: 'inboundNatPool1'
  properties: {
    protocol: 'Tcp'
    frontendPortRangeStart: '50000'
    frontendPortRangeEnd: '50119'
    backendPort: '3389'
  }
}
param loadBalancerInboundNatRule bool = false
param loadBalancerInboundNatRules object = {
  name: 'inboundNatRule1'
  properties: {
    protocol: 'Tcp'
    frontendPortRangeStart: '500'
    frontendPortRangeEnd: '1000'
    backendPort: '3389'
    enableFloatingIP: 'true'
    idleTimeoutInMinutes: '15'
    enableTcpReset: true
  }
}

@description('Specifies the probes that are requried for the LB, one or more required')
param loadBalancerRules object = {
  name: 'lbrule'
  properties: {
    enableFloatingIP: true
    protocol: 'Tcp'
    frontendPort: 80
    backendPort: 80
    idleTimeoutInMinutes: 15
    loadDistribution: 'SourceIPProtocol'
    disableOutboundSnat: true
    enableTcpReset: false
  }
}

@description('Specifies the load balancing rules for the LB')
param loadBalancerProbes object = {
  name: 'httpCheck'
  properties: {
    protocol: 'Http'
    port: 80
    requestPath: '/'
    intervalInSeconds: 5
    numberOfProbes: 2
  }
}
param location string = resourceGroup().location
param diagnostics object = {
  subscription: '803d2ea3-46d4-437b-b338-97801f68a808'
  resourceGroup: 'rg-logag-mngt-d'
  workspaceName: 'law-logag-d-mngt-oc'
  storageAccount: 'stdiaglogagdmngtaueoc'
}
param resourceTags object = {
  Project: ''
  Zone: 'Identity'
  Stream: 'IDAM'
  LastDeployed: utcNow('d')
}
var loadBalancerDiagnosticName = '${loadBalancerName}-diag'

var subnetRef = resourceId(vNetResourceGroupName, 'Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
var loadBalancerInboundNatPools_var = [
  {
    name: loadBalancerInboundNatPools.Name
    properties: {
      frontendIPConfiguration: {
        id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', loadBalancerName, loadBalancerFrontEndIPConfigName)
      }
      protocol: loadBalancerInboundNatPools.properties.protocol
      frontendPortRangeStart: loadBalancerInboundNatPools.properties.frontendPortRangeStart
      frontendPortRangeEnd: loadBalancerInboundNatPools.properties.frontendPortRangeEnd
      backendPort: loadBalancerInboundNatPools.properties.backendPort
    }
  }
]
var loadBalancerInboundNatRules_var = [
  {
    name: loadBalancerInboundNatRules.Name
    properties: {
      frontendIPConfiguration: {
        id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', loadBalancerName, loadBalancerFrontEndIPConfigName)
      }
      protocol: loadBalancerInboundNatRules.properties.protocol
      frontendPortRangeStart: loadBalancerInboundNatRules.properties.frontendPortRangeStart
      frontendPortRangeEnd: loadBalancerInboundNatRules.properties.frontendPortRangeEnd
      enableFloatingIP: loadBalancerInboundNatRules.properties.enableFloatingIP
      enableTcpReset: loadBalancerInboundNatRules.properties.enableTcpReset
      idleTimeoutInMinutes: loadBalancerInboundNatRules.properties.idleTimeoutInMinutes
      backendPort: loadBalancerInboundNatRules.properties.backendPort
      backendAddressPool: {
        id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, loadBalancerBackEndPoolName)
      }
    }
  }
]

resource loadBalancer 'Microsoft.Network/loadBalancers@2021-08-01' = {
  name: loadBalancerName
  location: location
  sku: {
    name: loadBalancerSKU
    tier: loadBalancerTier
  }
  tags: resourceTags
  properties: {
    frontendIPConfigurations: [
      {
        name: loadBalancerFrontEndIPConfigName
        properties: {
          subnet: {
            id: subnetRef
          }
          privateIPAddress: ((loadBalancerFrontEndIP == 'null') ? json('null') : loadBalancerFrontEndIP)
          privateIPAddressVersion: 'IPv4'
          privateIPAllocationMethod: ((loadBalancerFrontEndIP == 'null') ? 'Dynamic' : 'Static')
        }
      }
    ]
    backendAddressPools: [
      {
        name: loadBalancerBackEndPoolName
      }
    ]
    inboundNatPools: ((loadBalancerInboundNatPool == bool('true')) ? loadBalancerInboundNatPools_var : json('[]'))
    inboundNatRules: ((loadBalancerInboundNatRule == bool('true')) ? loadBalancerInboundNatRules_var : json('[]'))
    probes: [
      loadBalancerProbes
    ]
    loadBalancingRules: [
      {
        name: loadBalancerRules.name
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIpConfigurations', loadBalancerName, loadBalancerFrontEndIPConfigName)
          }
          frontendPort: loadBalancerRules.properties.frontendPort
          backendPort: loadBalancerRules.properties.backendPort
          enableFloatingIP: loadBalancerRules.properties.enableFloatingIP
          idleTimeoutInMinutes: loadBalancerRules.properties.idleTimeoutInMinutes
          protocol: loadBalancerRules.properties.protocol
          loadDistribution: loadBalancerRules.properties.loadDistribution
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', loadBalancerName, loadBalancerProbes.name)
          }
          disableOutboundSnat: loadBalancerRules.properties.disableOutboundSnat
          enableTcpReset: loadBalancerRules.properties.enableTcpReset
          backendAddressPools: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, loadBalancerBackEndPoolName)
            }
          ]
        }
      }
    ]
  }
}

resource LoadBalancerDiagnostics 'Microsoft.Insights/diagnosticSettings@2017-05-01-preview' = {
  name: loadBalancerDiagnosticName
  scope: loadBalancer
  properties: {
    workspaceId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.OperationalInsights/workspaces/', diagnostics.workspaceName)
    storageAccountId: resourceId(diagnostics.subscription, diagnostics.resourceGroup, 'Microsoft.Storage/storageAccounts', diagnostics.storageAccount)
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
  dependsOn: [
    loadBalancer
  ]
}

module NicUpdate './vm-nic-update.bicep' = if (!empty(loadBalancerBackendVMs)) {
  name: 'NicUpdate'
  params: {
    loadBalancerName: loadBalancerName
    loadBalancerBackendPoolName: loadBalancerBackEndPoolName
    loadBalancerBackendVMs: loadBalancerBackendVMs
    subnetRef: subnetRef
    location: location
  }
  dependsOn: [
    loadBalancer
  ]
}


output loadBalancerName string = loadBalancerName
output loadBalancerBackendPoolName string =  loadBalancer.properties.backendAddressPools[0].name

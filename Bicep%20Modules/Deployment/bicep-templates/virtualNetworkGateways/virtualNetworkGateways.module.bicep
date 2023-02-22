@description('Virtual network object')
param vgwObject object
param location string
param name string
param tags object
param workspaceName string
param workspaceGroup string
param networkGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string
param pipPrefix string
param vnPrefix string

// Existing resources required
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}
resource publicIp 'Microsoft.Network/publicIPAddresses@2021-05-01' existing = {
  name: '${pipPrefix}${vgwObject.pipName}'
  scope: resourceGroup(subscription().subscriptionId,networkGroup)
}
resource subnet 'Microsoft.Network/virtualnetworks/subnets@2015-06-15' existing = {
  name: '${vnPrefix}${vgwObject.vnetName}/GatewaySubnet'
  scope: resourceGroup(subscription().subscriptionId,networkGroup)
}

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2021-05-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    activeActive: false
    enableBgp: false
    gatewayType: 'Vpn'
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: subnet.id
          }
        }
      }
    ]
    sku: {
      name: vgwObject.sku
      tier: vgwObject.sku
    }
    vpnClientConfiguration: {
      aadAudience: vgwObject.aadAudience
      aadIssuer: vgwObject.aadIssuer
      aadTenant: vgwObject.aadTenant
      vpnAuthenticationTypes: [
        vgwObject.vpnAuthenticationTypes
      ]
      vpnClientAddressPool: {
        addressPrefixes: [
          vgwObject.addressPrefixes
        ]
      }
      // vpnClientIpsecPolicies: [
      //   {
      //     dhGroup: 'string'
      //     ikeEncryption: 'string'
      //     ikeIntegrity: 'string'
      //     ipsecEncryption: 'string'
      //     ipsecIntegrity: 'string'
      //     pfsGroup: 'string'
      //     saDataSizeKilobytes: int
      //     saLifeTimeSeconds: int
      //   }
      // ]
      vpnClientProtocols: [
        vgwObject.vpnClientProtocols
      ]
    }
    vpnGatewayGeneration: vgwObject.vpnGatewayGeneration
    vpnType: vgwObject.vpnType
  }
}

resource diagnostics 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  scope: virtualNetworkGateway
  name: name
  properties: {
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
      }
    ]
    storageAccountId: storageAccount.id
    workspaceId: logAnalytics.id
  }
}

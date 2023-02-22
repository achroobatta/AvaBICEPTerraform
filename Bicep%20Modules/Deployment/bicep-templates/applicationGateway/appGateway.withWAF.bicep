// Params from the *.parameters.json file
param agwObject object
param vnetObject object
param pipObject object
param nsgObject object

// Tagging parameters
param location string
param deployDate string

param appGatwayRG string

// Params from the global.yml VGS
param environmentType string
param pipPrefix string
param vmPrefix string
param vnPrefix string
param snPrefix string
param nsgPrefix string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountName string
param loggingStorageAccountGroup string


@description('Admin username for the backend servers')
param adminUsername string
param adminPasswd string

var testVMname = 'myVM'
var vmNic_name = 'net-int'
var ipconfig_name = 'ipconfig'


module pipModule '../publicIpAddresses/publicIpAddresses.module.bicep' = [for i in range(0, 2): {
  name: '${pipPrefix}${pipObject.pip.name}${i+1}'
  scope: resourceGroup(appGatwayRG)
  params: {
    pipObject: pipObject.pip
    name: '${pipPrefix}${pipObject.pip.name}${i+1}'
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    hubSubscription: hubSubscription
    loggingStorageAccountName: loggingStorageAccountName
    loggingStorageAccountGroup: loggingStorageAccountGroup
    location: location
    tags:{
      Environment: environmentType
      DeployDate: deployDate
      Owner: resourceGroup().tags.Owner
      CostCentre: resourceGroup().tags.CostCentre
      Application: resourceGroup().tags.Application
    }
  }
}]

resource nsgModule 'Microsoft.Network/networkSecurityGroups@2021-08-01' = [for i in range(0, 2): {
  name: '${nsgPrefix}${nsgObject.nsg.name}${i+1}'
  location: location
  tags: resourceGroup().tags
  properties: {
    securityRules: nsgObject.nsg.rules
  }
}]

module vNet '../virtualNetworks/virtualNetworks.module.bicep' = {
  name: '${appGatwayRG}-deploy-vnet'
  scope: resourceGroup(appGatwayRG)
  params: {
    vnetObject: vnetObject.vnet
    location: location
    name: '${vnPrefix}${vnetObject.vnet.name}'
    snPrefix: snPrefix
    nsgPrefix: nsgPrefix
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    hubSubscription: hubSubscription
    loggingStorageAccountName: loggingStorageAccountName
    loggingStorageAccountGroup: loggingStorageAccountGroup
    tags: resourceGroup().tags
  }
}

module appGateway './applicationGateway.module.bicep' = {
  name: '${agwObject.appGatewayName}-${deployDate}'
  scope: resourceGroup(appGatwayRG)
  params: {
    appGatewayName: '${agwObject.appGatewayName}'
    location: location
    tags:resourceGroup().tags
    appGatewaySKU: agwObject.appGatewaySKU
    appGatewayTier: agwObject.appGatewayTier
    zoneRedundant: agwObject.zoneRedundant
    publicIpAddressName: '${pipPrefix}apw-pubip'
    vNetResourceGroup: resourceGroup().name
    vNetName: '${vnPrefix}${vnetObject.vnet.name}'
    subnetName: '${snPrefix}appgw-snet'
    frontEndPorts: agwObject.frontEndPorts
    httpListeners: agwObject.httpListeners
    backendAddressPools: agwObject.backendAddressPools
    backendHttpSettings: agwObject.backendHttpSettings
    requestRoutingRules: agwObject.requestRoutingRules
    //enableDeleteLock: true
    enableDiagnostics: true
    workspaceName: workspaceName
    workspaceGroup: workspaceGroup
    hubSubscription: hubSubscription
    loggingStorageAccountName: loggingStorageAccountName
    loggingStorageAccountGroup: loggingStorageAccountGroup
  }
  dependsOn: [
    vNet
  ]
}


resource vmNics 'Microsoft.Network/networkInterfaces@2021-08-01' = [for i in range(0, 2): {
  name: '${vmNic_name}${(i + 1)}'
  location: location
  tags: resourceGroup().tags
  properties: {
    ipConfigurations: [
      {
        name: '${ipconfig_name}${(i + 1)}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', '${pipPrefix}${pipObject.pip.name}${i+1}')
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', '${vnPrefix}${vnetObject.vnet.name}', '${snPrefix}appgw-backend-snet')
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
          applicationGatewayBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', '${agwObject.appGatewayName}', 'agwBackendPool')
            }
          ]
        }
      }
    ]
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    networkSecurityGroup: {
      id: resourceId('Microsoft.Network/networkSecurityGroups', '${nsgPrefix}${nsgObject.nsg.name}${i + 1}')
    }
  }
  dependsOn: [
    pipModule
    vNet
    appGateway
    nsgModule
  ]
}]

resource virtualMachines 'Microsoft.Compute/virtualMachines@2021-11-01' = [for i in range(0, 2): {
  name: '${vmPrefix}${testVMname}${(i + 1)}'
  location: location
  tags: resourceGroup().tags
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
        diskSizeGB: 127
      }
    }
    osProfile: {
      computerName: '${vmPrefix}${testVMname}${i + 1}'
      adminUsername: adminUsername
      adminPassword: adminPasswd
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
      }
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: resourceId('Microsoft.Network/networkInterfaces', '${vmNic_name}${i + 1}')
        }
      ]
    }
  }
  dependsOn: [
    vmNics
  ]
}]

resource setup_IIS_onVM 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = [for i in range(0, 2): {
  name: '${vmPrefix}${testVMname}${(i + 1)}/IIS'
  location: location
  properties: {
    autoUpgradeMinorVersion: true
    publisher: 'Microsoft.Compute'
    type: 'CustomScriptExtension'
    typeHandlerVersion: '1.4'
    settings: {
      commandToExecute: 'powershell Add-WindowsFeature Web-Server; powershell Add-Content -Path "C:\\inetpub\\wwwroot\\Default.htm" -Value $($env:computername)'
    }
  }
  dependsOn: [
    virtualMachines
  ]
}]


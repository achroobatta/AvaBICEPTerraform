@description('Virtual Machine object')
param vmObject object
// Credentials 
@secure()
param adminUserName string
@secure()
param adminPassword  string

//Params
param tags object
param location string
param networkGroup string
param loggingStorageAccountName string
param dataCollectionPrefix string
param computeGroup string
param name string
param vnPrefix string
param asgPrefix string
param avsPrefix string
param snPrefix string
param workspaceName string
param workspaceGroup string
param hubSubscription string
param loggingStorageAccountGroup string

// Create newtork variables based on environment
var storageUri = 'http://${loggingStorageAccountName}.blob.${environment().suffixes.storage}'
var availabilitySetName = '${avsPrefix}${vmObject.availabilitySet}'
var applicationSecurityGroupName = '${asgPrefix}${vmObject.applicationSecurityGroup}'
var networkInterfaceName = '${name}-nic-01'
var virtualNetworkName = '${vnPrefix}${vmObject.virtualNetwork}'
var subnetName = '${snPrefix}${vmObject.subnet}'
// Standard agent deployments
var agentObject = contains(vmObject.osType, 'Windows') ? json(loadTextContent('./windowsAgents.json')) : json(loadTextContent('./linuxAgents.json'))


// Existing resources required
resource subnet 'Microsoft.Network/virtualnetworks/subnets@2015-06-15' existing = {
  name: '${virtualNetworkName}/${subnetName}'
  scope: resourceGroup(subscription().subscriptionId,networkGroup)
}
resource availabilitySet 'Microsoft.Compute/availabilitySets@2021-07-01' existing = {
  name: availabilitySetName
  scope: resourceGroup(subscription().subscriptionId,computeGroup)
}
resource applicationSecurityGroup 'Microsoft.Network/applicationSecurityGroups@2021-05-01' existing = {
  name: applicationSecurityGroupName
  scope: resourceGroup(subscription().subscriptionId,networkGroup)
}
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' existing = {
  name: workspaceName
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: loggingStorageAccountName
  scope: resourceGroup(subscription().subscriptionId,loggingStorageAccountGroup)
}
resource dataCollectionRules 'Microsoft.Insights/dataCollectionRules@2021-04-01' existing= {
  name: '${dataCollectionPrefix}${vmObject.osType}'
  scope: resourceGroup(hubSubscription,workspaceGroup)
}
// Create NIC
resource networkInterface 'Microsoft.Network/networkInterfaces@2021-05-01' = {
  name: networkInterfaceName
  tags: tags
  location: location
  properties: {
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    ipConfigurations: [
      {
        name: 'ipconfig'
        properties: {
          applicationSecurityGroups: [
            {
              id: applicationSecurityGroup.id
            }
          ]
          primary: true
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet.id
          }

        }
      }
    ]
    nicType: 'Standard'
  }
}
// Enable diags on NIC
resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  scope: networkInterface
  properties: {
    logAnalyticsDestinationType: null
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          days: 30
          enabled: true
        }
        timeGrain: 'string'
      }
    ]
    storageAccountId: storageAccount.id
    workspaceId: logAnalytics.id
  }
}

resource virtualMachine 'Microsoft.Compute/virtualMachines@2021-07-01' = {
  name: name
  tags: tags
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    availabilitySet: {
      id: availabilitySet.id
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: storageUri
      }
    }
    hardwareProfile: {
      vmSize: vmObject.vmSize
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface.id
        }
      ]
    }
    osProfile: {
      adminPassword: adminPassword
      adminUsername: adminUserName
      allowExtensionOperations: true
      computerName: name
    }
    storageProfile: {
      imageReference: vmObject.imageReference
      osDisk: {
        name: '${name}-disk-os'
        createOption: 'FromImage'
        deleteOption: 'Detach'
        osType: vmObject.osType
        writeAcceleratorEnabled: false
        managedDisk: {
          storageAccountType: vmObject.storageAccountType
        }
      }
      dataDisks: [for disk in vmObject.disks : {
          name: '${name}-${disk.name}'
          createOption: 'Empty'
          deleteOption: 'Detach'
          diskSizeGB: disk.diskSize
          lun: disk.lun
          managedDisk: {
            storageAccountType: vmObject.storageAccountType
          }
          writeAcceleratorEnabled: disk.writeAcceleration
        }]
    }
  }
}

resource shutdown_computevm_name 'Microsoft.DevTestLab/schedules@2018-09-15' = {
  name: 'shutdown-computevm-${name}'
  location: location
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '1900'
    }
    timeZoneId: 'AUS Eastern Standard Time'
    targetResourceId: virtualMachine.id
    notificationSettings: {
      status:'Disabled'
    }
  }
}

// Extensions
resource agentExtension 'Microsoft.Compute/virtualMachines/extensions@2020-12-01' = [for agent in agentObject.agents: {
  parent: virtualMachine
  name: agent.name
  location: location
  properties: {
    publisher: agent.publisher
    type: agent.type
    typeHandlerVersion: agent.typeHandlerVersion
    enableAutomaticUpgrade: agent.enableAutomaticUpgrade
    autoUpgradeMinorVersion: true
  }
}]

// Data Collection for AMA
resource dataCollectionRuleAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2021-04-01' = {
  name: virtualMachine.name
  scope: virtualMachine
  properties: {
    description: 'DataCollectionRuleAssociation'
    //dataCollectionEndpointId: virtualMachine.id
    dataCollectionRuleId: dataCollectionRules.id
  }
}

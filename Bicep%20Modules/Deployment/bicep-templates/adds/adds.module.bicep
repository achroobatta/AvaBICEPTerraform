// Params from the *.parameters.json file
param addsObject object
param tags object 

// Params from the global.yml VGS
param networkGroup string
param vnPrefix string
param location string

// Existing resources required
resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' existing = {
  name: '${vnPrefix}${addsObject.vnetName}/AzureADDSSubnet'
  scope: resourceGroup(networkGroup)
}

resource domainName_resource 'Microsoft.AAD/DomainServices@2020-01-01' = {
  name: addsObject.domainName
  location: location
  tags: tags
  properties: {
    domainName: addsObject.domainName
    filteredSync: addsObject.filteredSync
    domainConfigurationType: addsObject.domainConfigurationType
    notificationSettings: addsObject.notificationSettings
    replicaSets: [
      {
        subnetId: subnet.id
        location: location
      }
    ]
    sku: addsObject.sku
  }
}

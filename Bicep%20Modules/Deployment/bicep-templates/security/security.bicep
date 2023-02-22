targetScope = 'subscription'

var enableSecurityCenterFor = [
  'KeyVaults'
  //'VirtualMachines'
  'StorageAccounts'
]

resource securityCenterPricing 'Microsoft.Security/pricings@2022-03-01' = [for name in enableSecurityCenterFor: {
  name: name
  properties: {
    pricingTier: 'Standard'
  }
}]

resource securityContacts 'Microsoft.Security/securityContacts@2017-08-01-preview' = {
  name: 'securityContacts'
  properties: {
    alertNotifications: 'On'
    alertsToAdmins: 'On'
    email: 'a.mcgregor@avanade.com'
  }
}

resource autoProvisioningSettings 'Microsoft.Security/autoProvisioningSettings@2017-08-01-preview' = {
  name: 'default' // Yes this needs to be default
  properties: {
    autoProvision: 'On'
  }
}


param miName string
param location string
param skuName string
param administratorLogin string
@secure()
param administratorLoginPassword string
param subnetID string
param vCores int
param storageSizeInGB int
param licenseType string


resource sqlMI 'Microsoft.Sql/managedInstances@2022-02-01-preview' = {
  name: miName
  location: location
  tags: resourceGroup().tags
  sku: {
    name: skuName
  }
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword:administratorLoginPassword
    collation: 'SQL_Latin1_General_CP1_CI_AS'
    licenseType: licenseType
    minimalTlsVersion: '1.2'
    storageSizeInGB: storageSizeInGB
    vCores: vCores
    managedInstanceCreateMode: 'Default'
    subnetId: subnetID
    timezoneId: 'UTC'
    zoneRedundant: false
    administrators: {
      administratorType: ''
      azureADOnlyAuthentication: false
      login: ''
      principalType: ''
      sid: ''
      tenantId: ''
    }
  }
} 

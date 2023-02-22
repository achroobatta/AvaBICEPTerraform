// ASEv3 Deployment Subnet Delegation

///////////////////////////////////////////////////////////////////////////////////////
// Parameter Definitions for Subnet Delegation
//////////////////////////////////////////////////////////////////////////////////////

@description('Required. The Virtual Network (vNet) Name.')
param virtualNetworkName string

@description('Required. The subnet Name of ASEv3.')
param subnetName string

@description('Required. The subnet Name Address Space of ASEv3.')
param subnetAddressSpace string

///////////////////////////////////////////////////////////////////////////////////////
// Resource Deployment Definitions
//////////////////////////////////////////////////////////////////////////////////////

resource virtualNetworkName_subnetName 'Microsoft.Network/virtualNetworks/subnets@2020-11-01' = {
  name: '${virtualNetworkName}/${subnetName}'
  properties: {
    addressPrefix: subnetAddressSpace
    delegations: [
      {
        name: 'Microsoft.Web.hostingEnvironments'
        properties: {
          serviceName: 'Microsoft.Web/hostingEnvironments'
        }
      }
    ]
  }
}

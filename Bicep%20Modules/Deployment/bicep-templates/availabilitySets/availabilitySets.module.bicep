@description('Availability Set object')
param avsObject object
param avsPrefix string
param location string
param tags object

resource symbolicname 'Microsoft.Compute/availabilitySets@2021-07-01' = {
  name: '${avsPrefix}${avsObject.name}'
  tags: tags
  location: location
  sku: {
     name: 'Aligned' // required for managed disks
   }
  properties: {
    platformFaultDomainCount: avsObject.faultDomains
    platformUpdateDomainCount: avsObject.updateDomains
    proximityPlacementGroup: (contains(avsObject, 'proximityPlacementGroup')) ?  {
      id: 'string'
    }: null
  }
}

// Creates a virtual network
@description('Azure region of the deployment')
param location string = resourceGroup().location

@description('Tags to add to the resources')
param tags object = {}

@description('Name of the virtual network resource')
param virtualNetworkName string

@description('Group ID of the network security group')
param networkSecurityGroupId string

@description('Virtual network address prefix')
param vnetAddressPrefix string = '192.168.0.0/16'

@description('private endpoint subnet address prefix')
param peSubnetPrefix string = '192.168.0.0/24'

@description('aci subnet address prefix')
param aciSubnetPrefix string = '192.168.1.0/24'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-07-01' = {
  name: virtualNetworkName
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
    subnets: [
      { 
        name: 'snet-pe'
        properties: {
          addressPrefix: peSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          networkSecurityGroup: {
            id: networkSecurityGroupId
          }
        }
      }
      { 
        name: 'snet-aci'
        properties: {
          addressPrefix: aciSubnetPrefix
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Disabled'
          networkSecurityGroup: {
            id: networkSecurityGroupId
          }
          delegations: [
            {
                name: 'ACIDelegationService'
                properties: {
                    serviceName: 'Microsoft.ContainerInstance/containerGroups'                    
                }
            }
        ]
        }
      }    
    ]
  }
}

output id string = virtualNetwork.id
output name string = virtualNetwork.name


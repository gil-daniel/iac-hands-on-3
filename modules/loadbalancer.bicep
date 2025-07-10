@description('Load Balancer Name')
param lbName string = 'lb-hands3'

@description('Location')
param location string = resourceGroup().location

// Optional: remove this param if unused
// @description('Subnet ID where the Load Balancer will be deployed')
// param subnetId string

// Reusable names
var frontendName = 'LoadBalancerFrontEnd'
var backendPoolName = 'BackendPool'
var probeName = 'tcpProbe'
var ruleName = 'http-rule'

resource publicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${lbName}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2023-04-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: frontendName
        properties: {
          publicIPAddress: {
            id: publicIP.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: backendPoolName
      }
    ]
    probes: [
      {
        name: probeName
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 2
        }
      }
    ]
    loadBalancingRules: [
      {
        name: ruleName
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontendName)
          }
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, backendPoolName)
          }
          probe: {
            id: resourceId('Microsoft.Network/loadBalancers/probes', lbName, probeName)
          }
          protocol: 'Tcp'
          frontendPort: 80
          backendPort: 80
          enableFloatingIP: false
          idleTimeoutInMinutes: 4
          loadDistribution: 'Default'
        }
      }
    ]
  }
}

output backendPoolId string = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, backendPoolName)
output publicIp string = publicIP.properties.ipAddress

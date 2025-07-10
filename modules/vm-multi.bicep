@description('Base name for the Virtual Machines')
param vmBaseName string = 'vmweb'

@description('Number of Virtual Machines to deploy')
param vmCount int = 2

@description('Size of each Virtual Machine (SKU)')
param vmSize string = 'Standard_B1s'

@description('Administrator username for the Virtual Machines')
param adminUsername string

@description('SSH public key used for secure authentication')
@secure()
param adminPublicKey string

@description('Resource ID of the subnet where the VMs will be placed')
param subnetId string

@description('Resource ID of the Load Balancer backend address pool')
param backendPoolId string

@description('Azure region where resources will be deployed')
param location string = resourceGroup().location

// Create a Network Interface Card (NIC) for each VM
resource nics 'Microsoft.Network/networkInterfaces@2023-04-01' = [for i in range(0, vmCount): {
  name: '${vmBaseName}-nic-${i}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
          loadBalancerBackendAddressPools: [
            {
              id: backendPoolId
            }
          ]
        }
      }
    ]
  }
}]

// Deploy multiple Linux Virtual Machines and attach their NICs
resource vms 'Microsoft.Compute/virtualMachines@2023-03-01' = [for i in range(0, vmCount): {
  name: '${vmBaseName}-${i}'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: '${vmBaseName}-${i}'
      adminUsername: adminUsername
      linuxConfiguration: {
        disablePasswordAuthentication: true
        ssh: {
          publicKeys: [
            {
              path: '/home/${adminUsername}/.ssh/authorized_keys'
              keyData: adminPublicKey
            }
          ]
        }
      }
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nics[i].id
        }
      ]
    }
  }
}]

@description('Location for all resources')
param location string = resourceGroup().location

@description('Virtual Network name')
param vnetName string = 'vnet-hands2'

@description('Address prefix for the Virtual Network')
param vnetPrefix string = '10.10.0.0/16'

@description('Subnet name')
param subnetName string = 'subnet-hands2'

@description('Address prefix for the subnet')
param subnetPrefix string = '10.10.1.0/24'

@description('Network Security Group name')
param nsgName string = 'nsg-hands2'

//@description('Network Interface name')
//param nicName string = 'nic-hands2'

// @description('Public IP name')
// param publicIpName string = 'pip-hands2'

// @description('Virtual Machine name')
// param vmName string = 'vm-hands2'

@description('Virtual Machine size')
param vmSize string = 'Standard_B1s'

@description('Admin username for the VM')
param adminUsername string = 'azureuser'

@description('SSH Public Key')
@secure()
param adminPublicKey string

@description('Base name for the Virtual Machines')
param vmBaseName string = 'vmweb'

@description('Number of Virtual Machines to deploy')
param vmCount int = 2

module network './modules/network.bicep' = {
  name: 'deployNetwork'
  params: {
    location: location
    vnetName: vnetName
    vnetPrefix: vnetPrefix
    subnetName: subnetName
    subnetPrefix: subnetPrefix
    nsgName: nsgName
  }
}

// module nic './modules/nic.bicep' = {
//   name: 'deployNIC'
//   params: {
//     location: location
//     nicName: nicName
//     publicIpName: publicIpName
//     subnetId: network.outputs.subnetId
//   }
// }

// module vm './modules/vm.bicep' = {
//   name: 'deployVM'
//   params: {
//     location: location
//     vmName: vmName
//     vmSize: vmSize
//     adminUsername: adminUsername
//     adminPublicKey: adminPublicKey
//     nicId: nic.outputs.nicId
//   }
// }

module lb './modules/loadbalancer.bicep' = {
  name: 'deployLoadBalancer'
  params: {
    lbName: 'lb-hands3'
    location: location
  }
}

module vmMulti './modules/vm-multi.bicep' = {
  name: 'deployMultiVM'
  params: {
    vmBaseName: vmBaseName
    vmCount: vmCount
    vmSize: vmSize
    adminUsername: adminUsername
    adminPublicKey: adminPublicKey
    subnetId: network.outputs.subnetId
    backendPoolId: lb.outputs.backendPoolId
    location: location
  }
}

// output publicIpAddress string = nic.outputs.publicIpAddress

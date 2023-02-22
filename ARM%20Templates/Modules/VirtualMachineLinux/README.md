# Introduction 
This template will deploy a Linux Virual Machine in the resource group.

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release | su.myat.khine.win |


## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Module Dependencies

| Module Name | Description | Tested Version | 
|---|---|---|
|Resource Group|Create the resource group before deploying. See ResourceGroup||
|Virtual Network|Create the virtual network before deploying||
|Public IP|Create the public IP address first to enable communication inbound.||
|networkSecurityGroupName|Network security group contains security rules that allow or deny inbound network traffic to, or outbound network traffic from, several types of Azure resources. ||

### Create resources using Azure cli and Azure Powershell commands 
- **Resource Group**
    - [Azure cli command ](https://docs.microsoft.com/en-us/cli/azure/group?view=azure-cli-latest#az-group-create)

    ```
        az group create -l westus -n MyResourceGroup
    ```
    - [Azure Powershell command ](https://docs.microsoft.com/en-us/powershell/module/az.resources/new-azresourcegroup?view=azps-8.1.0)

    ```
        New-AzResourceGroup -Name exampleGroup -Location westus
    ```
- **Virtual Network**
    - [Azure cli command ](https://docs.microsoft.com/en-us/azure/virtual-network/quick-create-cli)

    ```
        az network vnet create \
            --name myVNet \
            --resource-group CreateVNetQS-rg \
            --subnet-name default
    ```
    - [Azure Powershell command ](https://docs.microsoft.com/en-us/azure/virtual-network/quick-create-powershell)

    ```
        $vnet = @{
            Name = 'myVNet'
            ResourceGroupName = 'CreateVNetQS-rg'
            Location = 'EastUS'
            AddressPrefix = '10.0.0.0/16'    
        }
        $virtualNetwork = New-AzVirtualNetwork @vnet
    ```

- **Public IP**
    - [Azure cli command](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-cli?tabs=create-public-ip-standard%2Ccreate-public-ip-zonal%2Crouting-preference) 
    ```
    az network public-ip create \
        --resource-group QuickStartCreateIP-rg \
        --name myStandardPublicIP \
        --version IPv4 \
        --sku Standard \
        --zone 1 2 3||
    ```
    - [Azure Powershell command](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-powershell?tabs=create-public-ip-standard%2Ccreate-public-ip-zonal%2Crouting-preference) 

    ```
        $ip = @{
            Name = 'myStandardPublicIP'
            ResourceGroupName = 'QuickStartCreateIP-rg'
            Location = 'eastus2'
            Sku = 'Standard'
            AllocationMethod = 'Static'
            IpAddressVersion = 'IPv4'
            Zone = 1,2,3
        }
        New-AzPublicIpAddress @ip
    ```

- **Network Security Group**
    - [Azure cli command](https://docs.microsoft.com/en-us/cli/azure/network/nsg?view=azure-cli-latest#az-network-nsg-create) 

    ```
        az network nsg create -g MyResourceGroup -n MyNsg --tags super_secure no_80 no_22
    ```
    - [Azure Powershell command](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/create-public-ip-powershell?tabs=create-public-ip-standard%2Ccreate-public-ip-zonal%2Crouting-preference) 

    ```
        New-AzNetworkSecurityGroup -Name "nsg1" -ResourceGroupName "rg1"  -Location  "westus"
    ```

## Required Parameters

Resource naming convention is as per [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types) from Microsoft.

| Parameter Name | Description |  Type | 
|---|---|---|
| projectName | Virtual Linux machine name |  string |
|location|resource group location|string|
|adminUsername|administrator username| string|
|adminPublicKey|SSH public key||
|vmSize| - It is virtual machine size. The size that you choose then determines factors such as processing power, memory, and storage capacity. <br> - Types : General Purpose, Compute Optimised, Memory optimised, Storage optimised, GPU, High performance compute </br>|string|

## Optional/Advance Parameters
Reference for Azure Monitor diagnostics setting resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting

There are no advance or optional Parameters.



## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |

## Additional details
### Sample usage when using this module in your own modules

```

```

## References

- [Create a Linux Virtual Machine with SSH Keys](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.compute/vm-sshkey)
- [How to create a Linux virtual machine with Azure Resource Manager templates](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/create-ssh-secured-vm-from-template)
- [Private IP address allocation - Default is Dynamic](https://docs.microsoft.com/en-us/azure/virtual-network/ip-services/private-ip-addresses)
- [Recommended abbreviations for Azure resource types](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations)
- [Understand the structure and syntax of ARM templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/syntax)
- [Define your naming convention](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-naming#example-names-for-common-azure-resource-types)

---

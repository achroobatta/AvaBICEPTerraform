# Introduction 
Azure virtual machines are one of several types of on-demand, scalable computing resources that Azure offers. Typically, you choose a virtual machine when you need more control over the computing environment than the other choices offer. 

An Azure virtual machine gives you the flexibility of virtualization without having to buy and maintain the physical hardware that runs it. However, you still need to maintain the virtual machine by performing tasks, such as configuring, patching, and installing the software that runs on it.

| Version | Date | Release Notes | Author |
|---|---|---|--|
| 1.0 | July22 | First release | jenay.jeeva |

# Module Dependencies
- NIC

# Required Parameters 
| Parameter Name | Description | Type |
|---|---|---|
| location | Location for all resources |  string |
| adminUsername | The VM's admin username | string |
| adminPassword | The VM's admin password | secureString |
| OSVersion | The version of Windows operating system image to deploy the VM with | string |
| vmSize | The size of the VM | string |
| numberOfDataDisks | The quantity of data disks to deploy the VM with | int |
| sizeOfDataDisksInGB | The size of the data disks | int |
| osDiskStorageAccountType | The storage account type for the OS and data disk/s | string |
| vmName | The name of the VM | string |
| computerHostName | The name of the host computer | string |
| nicName | The name of the Network Interface Card for the Windows VM | string |

# Optional Parameters
| Parameter Name | Description | Type | 
There are no optional parameters. 

# References
- [Create a Windows virtual machine from a Resource Manager template](https://docs.microsoft.com/en-us/azure/virtual-machines/windows/ps-template)
- [Virtual Machines](https://azure.microsoft.com/en-au/services/virtual-machines/)
- [Virtual machines in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/overview)
# Introduction 

As part of the Sovereign MS with Adelaide Hub Delivery Model project, Azure Resource Manager (ARM) Templates are required to build.
This README.md document will outline the process/steps to build the required ARM templates.

```
    Tables of Contents
        - 1. Text Editor, VS Code Extensions and Resources
        - 2. ARM Templates - Learning Resources
        - 3. Git workflow and work process 
        - 4. Details Step of Templates Creation : Templates Setup and Group Variables 
        - 5. YML Pipeline 
        - 6. Basic Networking Fundamentals

```

The ARM templates contains two main folders :

|Folder|Explanation|
|---|---|
|Live|In this folder, only relevant parameters files should be kept.|
|Modules|In this folder, only generic relevant templates should be kept.|

---

## 1. Text Editor, VS Code Extensions and Resources
Visual Studio Code is recommended to develop the ARM templates. In VS Code extensions, search for the following two extensions and install them.
- Azure Resource Manager (ARM) Tools : Language server, editing tools and snippets for Azure Resource Manager (ARM) template files.
- ARM Template Viewer : Graphically display ARM templates in an interactive map view

---

## 2. ARM Templates - Learning Resources
- To give you a background knowledge of Infrastructure as Code and why ARM templates, Biceps and Terraform are used to created resources, refer to the following videos:
    - [What is Infrastructure as Code? Difference of Infrastructure as Code Tools](https://www.youtube.com/watch?v=POPP2WTJ8es)
    - [What is Infrastructure as Code?](https://www.youtube.com/watch?v=zWw2wuiKd5o&t=1s)
- If you are new to ARM templates, refer to the following resources to learn:
    - [Azure Resource Manager (ARM) Full Course Tutorial | Creating infrastructure in Azure using Code](https://www.youtube.com/playlist?list=PLGjZwEtPN7j8_kgw92LHBrry2gnVc3NXQ)
    - [ARM template best practices](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/best-practices)
    - Go through this[Recommended abbreviations for Azure resource types](https://docs.microsoft.com/en-us/azure/cloud-adoption-framework/ready/azure-best-practices/resource-abbreviations).
---
## 3. Git workflow and work process 

- 3.1.	Clone the [ARM Templates repository](https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20as%20our%20delivery%20center/_git/ARM-Templates) to your local machine.

    ```
        git clone https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20as%20our%20delivery%20center/_git/ARM-Templates

    ```
- 3.2.	Create a your own local branch and follow the following branch name convention and go to your newly created local branch.

    ```
        git checkout -b feature/yourfirstname_modules
        
    ```
- 3.3. Go to [Azure DevOps board](https://FY22-Asset-build-funding@dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/ARM-Templates) and find your assigned task. And update from Todo to InProgress and start working on your assigned task.

    - <img src="img/AzureDevOpsBoard_Task.png" width=500>
- 3.4. Research about the resource in MS Offical doc and [Azure azure-quickstart-templates github repo](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts) to get the template and modify it to suit.

    - 3.4.1. The overview process is below.

    ```
        Create Branch --> Code Changes -- > Add parameters (most of them) -->  Pull Request --> Set Approval to Vinita for Code review.
    ```
    - 3.4.2. After finishing the repo, commit the changes and push it to the main.

    ```
        git commit -m "YourNameIniitial: Name of the fils added"

        git push origin (feature/yourname_modules)
    ```
- 3.5. Create a PR request and add Vinita to review.

---

## 4. Details Step of Templates Creation : Templates Setup and Group Variables

- Get the template from Microsoft Quickstarts. **VirtualNetwork Template** will be used as an example to illustrate the following steps: 
    - Main Template Setup
    - Using other templates for the main template 
    - Setting up yml pipeline and identifying dependencies
    - Group Variables in the Pipeline library 

- **Main Template Setup**
    - Go To [quickstarts](https://github.com/Azure/azure-quickstart-templates) and search for the relevant template. In this case, the template to be created is [Virtual Private Network (VPN) gateway site to site connection](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.network/site-to-site-vpn-create). 
    
    - Click on the highlighted file link below and copy the content into the template.
        - <img src="img/vpngateway_sitetosite_template.png" width="600">
    - Use CTRL + Shift + P and select the to [ARM Viewer](https://marketplace.visualstudio.com/items?itemName=bencoleman.armview) from the options.This ARM Viewer displays a graphical preview of Azure Resource Manager (ARM) templates such as below. To create a virtual network gateways, it depends on VirtualNetworks and publicIP Addresses. 
        - From this below visual observation, it can be concluded that the following templates can be used to created the VirtualNetworks and publicIPAddreses.
        - <img src="img/vpngateway_site_to_site_Illustration.png" width="600">

- **Using other templates for the main template** 
    - **VirtualNetwork & PublicIPAddress** 
        - To use the Virtual Network template, first the followings need to be deleted from the quickstart template since these resources, vnet and publicIP Address, have their corresponding templates in the Modules and they can be used to create the VPNGateway site to site connection resource.
        - <img src="img/vnet_publicIPAddress_templates.png" width="600">
        - When you delete any resources, please ensure you also delete associated resources from the parameters section, variables and also in the parameters.json file.
        - <img src="img/vpngateway_deletedparameters.png" width="600">

- **Setting up yml pipeline and identifying dependencies**
    - Following the deletion of virtual networks and publicIPAddress from the **vpngateway_sitetosite.json** template, the relevant parameters and variablesID need to be updated. 
        - In the overridparameters in yml pipeline, pass the resource name and the value must be from either variable group as shown in the below diagram or the parameterfile.
        - <img src="img/vpngateway_variables.png" width="700">
- **Group Variables in the Pipeline library**
    - In the Azure devops library, all the variables related to the group can be grouped together. For this project, the library consists of variable group.
    - Please ensure all the required variables are added in the library.
        - <img src="img/variables_group.png" width="600">
    - To get the correct format id, check in the json view which is located in the top right corner of the resource in the portal.
        - <img src="img/publicIDAddress_ID.png" width="800">
    - In last step, write stage and jobs for the VPNGateway site to site connection in the YML pipeline and add the relevant variables names in the override parameters sections. See below.
    - <img src="img/override_parameters.png" width="800">

---

## 5. YML Pipeline fundamentals 



## 6. Basic Networking Fundamentals
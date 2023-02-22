# Introduction 

As part of the Sovereign MS with Adelaide Hub Delivery Model project, Biceps Templates are required to build.
This README.md document will outline the process/steps to build the required Biceps templates and how to use them.

    ```
        Tables of Contents
            - 1. What is Biceps, Text Editor, VS Code Extensions 
            - 2. Biceps - Learning Resources
            - 3. Git workflow and work process 
            - 4. Details Step of Templates Creation : Templates Setup and Group Variables 
            - 5. YML Pipeline 
            - 6. Basic Networking Fundamentals

    ```

## 1. What is Biceps, Text Editor, VS Code Extensions and Resources

- **What is Biceps?**
[Bicep is a domain-specific language (DSL) that uses declarative syntax to deploy Azure resources](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep). In a Bicep file, you define the infrastructure you want to deploy to Azure, and then use that file throughout the development lifecycle to repeatedly deploy your infrastructure. Your resources are deployed in a consistent manner.

Bicep provides concise syntax, reliable type safety, and support for code reuse. Bicep offers a first-class authoring experience for your infrastructure-as-code solutions in Azure.

- Visual Studio Code is recommended to develop the Bicep template. In VS Code extensions, search for the following two extensions and install them.
- Bicep : The Bicep VS Code extension is capable of many of the features you would expect out of other language tooling. Here is a comprehensive list of the features that are currently implemented.
- ARM Template Viewer : Graphically display ARM templates in an interactive map view

## 2. Biceps - Learning Resources
    - [What is Bicep?](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep)
    - [Fundamentals of Bicep](https://docs.microsoft.com/en-gb/learn/paths/fundamentals-bicep/)
    - [Learn Live: Use Bicep to deploy your Azure infrastructure as code](https://docs.microsoft.com/en-gb/events/learn-events/learnlive-iac-and-bicep/)
    - [Azure cli overview](https://www.youtube.com/watch?v=DOywwse_j8I)
    - [Bicep Advanced Deployments - Part 1](https://www.youtube.com/watch?v=wevlRsVxsUw&t=320s)
    - [Migrate to Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/migrate)
    - [Decompiling ARM template JSON to Bicep](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/decompile?tabs=azure-cli)

- **Useful biceps cli**
    - Convert ARM template JSON to a bicep file
    ```
        az bicep decompile --file main.json
    ```
    - adds the Bicep CLI to your local environment
    ```
        az bicep install
    ```

## 3. Git workflow and work process 

## 4. Details Step of Templates Creation : Templates Setup and Group Variables 

- **Create a bicep file from ARM template** 
    - If the bicep file is already created in the file, you don't have to run the command.
    - Change into the template folder. Run `az bicep decompile --file yourARMtemplate.json` command.
    - This will automatically generate the bicep file.
- [Create Bicep parameter file](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/parameter-files)

- Deployment of biceps files can be done in multiple ways:
    - [Deploy via VS Code](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-vscode)
    - [Deploy via CLI](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-cli)
    - [Deploy via PowerShell](https://docs.microsoft.com/en-us/azure/azure-resource-manager/bicep/deploy-powershell)
- **Azure CLI Installation for testing**
- [Install Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli)
    - Download latest release of the Azure ClI 
    - Open the downloaded file and follow instructions for installation.
- Once you have finished installing, close the VS Code if you have already opened. Reopen the VS Code editor.
    - Open a new terminal by Terminal => New Terminal from the menu or use short cut ***Ctrl + J*** 
    - log in to your Azure account `az login`. 
    - After you successfully login, you should see below.
        - <img src="./img/az_login.png" >
    - You can also run this command `az account show` to verify.

## 5. [YML pipeline](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/key-pipelines-concepts?view=azure-devops) 

- The following components make up the yaml pipeline.
- A pipeline is made up of one or more stages. A pipeline can deploy to one or more environments.
    - **jobs** : Each job runs on one agent. A job can also be agentless. Defines the execution sequence of a set of steps.
    - **stages** : Organizes jobs within a pipeline. A stage is a way of organizing jobs in a pipeline and each stage can have one or more jobs.
    - **steps** : A step can be a task or script and is the smallest building block of a pipeline.
    - variablegroups (vgs) : 
- <img src= "./img/yaml_pipeline_concepts.png" width=500>



# References 
- [Learn Live: Use Bicep to deploy your Azure infrastructure as code](https://docs.microsoft.com/en-gb/events/learn-events/learnlive-iac-and-bicep/)

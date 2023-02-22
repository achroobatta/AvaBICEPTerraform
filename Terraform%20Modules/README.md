# Introduction 
- Making simple things simple and complicated things possible
- Modules must provide value for it to exist; otherwise, users are better off using the Azure resource providers directly which are maintained regularly by Microsoft
- Highly reusable with no client or environment specific configurations, while balancing industry wide best practices baked in when possible

Achieved by:
- Strive to expose all settings made available from Azure resource provider whenever possible
- Hide complexity of modules by making less commonly used settings optional 
- Bundle all related resources that are related to a single activity together (e.g. VM provisioning should include disks and NICs)
- Enforce settings when there are unacceptable security risk (e.g. prevent usage of unsecured channels like http)

# Using the modules from another repo
In the terraform configuration, call the following source:
```
source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VirtualNetwork/"
```
After requesting or creating a PAT from the owner of this repo, create a sensitive variable called "pattoken" and populate the PAT value into it. Create a task to run the following command in your release pipeline before Terraform init:
```
cd $(System.DefaultWorkingDirectory)
git config --global url."https://$(pattoken)@dev.azure.com".insteadOf "https://dev.azure.com"
```

If PAT cannot or are not provided, clone the files in this repo into your repo and update the source to use local directories.
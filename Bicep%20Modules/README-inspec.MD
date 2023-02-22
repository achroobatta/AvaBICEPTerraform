# Introduction
Chef InSpec is an open-source framework for testing and auditing your applications and infrastructure. Chef InSpec works by comparing the actual state of your system with the desired state that you express in easy-to-read and easy-to-write Chef InSpec code. Chef InSpec detects violations and displays findings in the form of a report, but puts you in control of remediation.



## Create a profile
Profiles are the core of the Chef InSpec testing experience. Use Chef InSpec profiles to manage everything you need to run a security or compliance scan–attributes, metadata, and the tests themselves.

## Create tests and run InSpec
Run your tests wherever your infrastructure is–locally or in the cloud. Chef InSpec is designed for platforms and treats operating systems as special cases. Chef InSpec helps you, whether you use Windows Server on your own hardware or run Linux in Docker containers in the cloud. As for the cloud, you can use Chef InSpec to target applications and services running on AWS and Azure.

## Standard Structure of Inspec 

```
examples/profile
├── README.md
├── controls
│   ├── resource1.rb
│   └── resource1.rb
├── libraries
│   └── extension.rb
|── files
│   └── extras.conf
└── inspec.yml
```
where:

- inspec.yml includes the profile description (required)
- controls is the directory in which all tests are located (required)
- libraries is the directory in which all Chef InSpec resource extensions are located (optional)
- files is the directory with additional files that a profile can access (optional)
- README.md should be used to explain the profile, its scope, and us

## Current Inspec structure

```
inspec-tests/azure
├── controls
│   ├── bastion_hosts_resource.rb
│   ├── key_vaults.rb
│   ├── network_security_group.rb
│   ├── public_ip.rb
│   ├── resource_group.rb
│   ├── storage_account.rb
│   ├── subnet.rb
│   ├── virtual_machine.rb
│   ├── virtual_network_gateway.rb
│   ├── virtual_network_peerings.rb
│   └── virtual_network.rb
├── environments
│   ├── dev
│   │    ├── bastion_hosts_resource.yml
│   │    ├── key_vaults.yml
│   │    ├── network_security_group.yml
│   │    ├── public_ip.yml
│   │    ├── resource_group.yml
│   │    ├── storage_account.yml
│   │    ├── subnet.yml
│   │    ├── virtual_machine.yml
│   │    ├── virtual_network_gateway.yml
│   │    ├── virtual_network_peerings.yml
│   │    └── virtual_network.yml       
│   ├── prod
│   └── test
│── files
│   └── extras.conf
└── inspec.yml
```
where:

- inspec.yml includes the profile description 
- controls is the directory in which all tests are located 
- environments folder has all the resources listed under each environment 
- files is the directory with additional files that a profile can access. Here all the files which are in "environments" folder are copied in "files" folder and then inspec exec is run. 


`If any resource is added to the repository, please add the corresponding inspec test under "controls" folder and add the name under "environments" folder.`

`There are different profile created for dedicated production servers, which are in "servers" folder.`


# Pipeline

inspec-pipeline.yml
```
trigger: 
  none

pool: ubuntu-vmss # on premises running required to run network tests


variables:
  - name: environmentType
    value: dev 
  - name: serviceConnection
    value: myVSPsubscription 
  - name: poolType
    value: selfHosted # alternative is hosted
  - name: keyVaultName
    value: kv-prod-ae-sec-16  # needs to fixed
  - name: secretsFilter
    value: svcwinrm # alternative is hosted
#  - group: inspec-${{variables.environmentType}}
  - group: vb-inspec-dev

stages:
- stage: test
  jobs:
  - job: Inspec_tests
    steps:

    #Install tasks
      - task: UseRubyVersion@0
        condition: eq(variables.poolType, 'hosted')
        displayName: 'Install Ruby on hosted agent'
        inputs:
          versionSpec: '>= 2.5'
          addToPath: true
      - task: Bash@3
        condition: eq(variables.poolType, 'selfHosted')
        displayName: 'Install Ruby on self-hosted agent'
        inputs:
          targetType: inline
          script: |
            sudo apt update
            sudo apt install ruby-full -y
      - script: curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P inspec
        displayName: 'Install Inspec'
      - script: sudo wget https://github.com/mikefarah/yq/releases/download/v4.27.2/yq_linux_amd64 -O /usr/bin/yq && sudo chmod +x /usr/bin/yq
        displayName: 'Install yq'

    # Run Tests for Azure
      - task: Bash@3
        displayName: 'Run azure inspec tests'
        inputs:
          targetType: inline
          script: |
            export AZURE_SUBSCRIPTION_ID=$(AZURE_SUBSCRIPTION_ID)
            export AZURE_CLIENT_ID=$(AZURE_CLIENT_ID)
            export AZURE_CLIENT_SECRET=$(AZURE_CLIENT_SECRET)
            export AZURE_TENANT_ID=$(AZURE_TENANT_ID)
            cp ./Deployment/inspec-tests/azure/environments/$(environmentType)/*.yml ./Deployment/inspec-tests/azure/files/
            inspec exec ./Deployment/inspec-tests/azure -t azure:// --chef-license=accept --reporter cli junit2:test-azure.xml
      - task: PublishTestResults@2
        displayName: Publish azure inspec test results
        condition: succeededOrFailed()
        inputs:
          testResultsFiles: '**/test-azure.xml'
          mergeTestResults: true

    # Run tests for infra
      # - task: AzureKeyVault@2
      #   displayName: 'Azure Key Vault: Creds to run WinRM'
      #   inputs:
      #     azureSubscription: ${{variables.serviceConnection}}
      #     keyVaultName: ${{variables.KeyVaultName}}
      #     secretsFilter: ${{variables.secretsFilter}}
      # - task: Bash@3
      #   displayName: 'Run server inspec tests'
      #   condition: always()
      #   inputs:
      #     targetType: inline
      #     script: |
      #       cp ./Deployment/inspec-tests/servers/environments/$(environmentType)/servers.yml ./Deployment/inspec-tests/servers/
      #       readarray -t servers < <(yq '.[].name' ./Deployment/inspec-tests/servers/servers.yml) 
      #       readarray -t roles < <(yq '.[].role' ./Deployment/inspec-tests/servers/servers.yml)
      #       length=${#servers[@]}
      #       for ((j=0;j<${length};j++)); do inspec exec ./Deployment/inspec-tests/servers/${roles[j]} -b winrm  --host ${servers[j]} --password '$(svcwinrm)' --user ${{variables.secretsFilter}} --chef-license=accept --reporter cli junit2:test-${servers[j]}-${roles[j]}.xml; done
      # - task: PublishTestResults@2
      #   displayName: Publish server inspec test results
      #   condition: succeededOrFailed()
      #   inputs:
      #     testResultsFiles: '**/test-*.xml'
      #     mergeTestResults: true


```


Note: `The commented steps in pipeline belong to dedicated resource/profiles created for production environment. To login the servers, the "winrm" account is used whose password is fetched from Key Vault. ` 
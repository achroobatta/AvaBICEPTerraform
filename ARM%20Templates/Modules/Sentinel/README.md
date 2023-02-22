# Introduction 
It deploys a sentinel SIEM solution

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | Aug22 | First release | Vinita Bhasin |

# Module Dependencies
It should have Log analytics workspcae created before deploying sentinel.
# Required Parameters
| Parameter Name | Description | Type | Default value |
|---|---|---|---|
| workspaceName | log anlytics workspace name | string | 
| location | region | string | "[resourceGroup().location]" |
|
# Introduction 
It deploys express route circuit. Another template is used to create private peerings to Express route. 

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | Aug22 | First release | Vinita Bhasin |

# Module Dependencies
To create peerings, express route circiuit should be created.
i.e. please create ckt using the template erCktCreate.json followed by creating peerings using erPrivatePeeringVnet.json 

# Required Parameters
| Parameter Name | Description | Type | Default value |
|---|---|---|---|
| erCktName | Circuit name  | string | 
| location | region | string | "[resourceGroup().location]" |
|
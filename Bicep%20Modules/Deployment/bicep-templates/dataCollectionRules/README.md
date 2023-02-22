# Despite the doco

No registered resource provider found for location 'AustraliaEast' and API version '2021-09-01-preview' for type 'dataCollectionRules'. The supported api-versions are '2019-11-01-preview, 2021-04-01'. The supported locations are 'australiasoutheast, canadacentral, japaneast, australiaeast, centralindia, germanywestcentral, northcentralus, southcentralus, eastus, centralus, westeurope, westus2, southeastasia, eastus2, uksouth, northeurope, westus, australiacentral, westcentralus, eastasia, ukwest, koreacentral, francecentral, southafricanorth, switzerlandnorth, australiacentral2, brazilsoutheast, canadaeast, francesouth, koreasouth, norwaywest, uaenorth, japanwest, norwayeast, switzerlandwest, brazilsouth, jioindiacentral, jioindiawest, swedencentral, southindia, uaecentral, westus3, westindia'


# Errors in the documentatino
```bicep
      syslog: [
        {
          facilityNames: [
            'string'
          ]
          logLevels: [
            'string'
          ]
          name: 'string'
          streams: 'string'
        }
      ]
```

streams is actually an array and if not specified as such generates thi very unifromative error

/usr/bin/bash /home/vsts/work/_temp/azureclitaskscript1652757746348.sh
ERROR: {"status":"Failed","error":{"code":"DeploymentFailed","message":"At least one resource deployment operation failed. Please list deployment operations for details. Please see https://aka.ms/DeployOperations for usage details.","details":[{"code":"Conflict","message":"{\r\n  \"status\": \"Failed\",\r\n  \"error\": {\r\n    \"code\": \"ResourceDeploymentFailure\",\r\n    \"message\": \"The resource operation completed with terminal provisioning state 'Failed'.\",\r\n    \"details\": [\r\n      {\r\n        \"code\": \"DeploymentFailed\",\r\n        \"message\": \"At least one resource deployment operation failed. Please list deployment operations for details. Please see https://aka.ms/DeployOperations for usage details.\",\r\n        \"details\": [\r\n          {\r\n            \"code\": \"BadRequest\",\r\n            \"message\": \"{\\r\\n  \\\"error\\\": {\\r\\n    \\\"code\\\": \\\"InvalidProperty\\\",\\r\\n    \\\"message\\\": \\\"Resource payload is missing or invalid.\\\",\\r\\n    \\\"details\\\": [\\r\\n      {\\r\\n        \\\"code\\\": \\\"InvalidProperty\\\",\\r\\n        \\\"message\\\": \\\"Resource payload is missing or invalid.\\\",\\r\\n        \\\"target\\\": \\\"\\\"\\r\\n      }\\r\\n    ]\\r\\n  }\\r\\n}\"\r\n          }\r\n        ]\r\n      }\r\n    ]\r\n  }\r\n}"}]}}
##[error]Script failed with exit code: 1
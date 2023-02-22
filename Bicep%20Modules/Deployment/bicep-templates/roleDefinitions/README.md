# Introduction 
This template deploys a role at the intended scope 

## Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0.0 | July22 | First release |  |

## Developed On
| Module Version | AzureRM Version |
|---|---|
| 1.0 | |


## Required Parameters

| Parameter Name | Description |  Type | 
|---|---|---|
| roleName | name of the role assignment | string |
| description | description of the role assignment | string |
| type | type of role assignment | string | 
| actions | actions to be performed | list["string1", "string2"] | 
| notActions | exemptions | list["string1", "string2"] | 
| assignableScopes | role assignment scope | list["string1", "string2"] | 


## Optional/Advance Parameters

There are no advance or optional Parameters.



## Outputs
There are no outputs.

| Parameter Name | Description | Type | 
|---|---|---|
|  |  |  |



## References

- e.g.
```Powershell
new-azroleassignment -ApplicationId fb50fca9-3f8b-4fa7-8f65-3fac1f53b958  -Scope "/" -RoleDefinitionName "Owner"
```


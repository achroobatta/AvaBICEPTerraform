# Introduction 
Creates a vpn server configuration and a point 2 site vpn gateway. Do not use this module for site 2 site vpn gateway.

# Version
| Version | Date | Release Notes | Author |
|---|---|---|---|
| 1.0 | Aug22 | First release | viktor.lee |

# Developed On
| Module Version | Terraform Version | AzureRM Version |
|---|---|---|
| 1.0 | 1.1.7 | 3.13.0 |

# Module Dependencies
There are no dependencies

| Module Name | Description | Tested Version |
|---|---|---|


# Required Parameters
| Parameter Name | Description | Type | 
|---|---|---|
| name | Name of the resources | string |
| location | Location of the resources | string |
| resource_group_name | Name of the RG | string |
| tags | Azure Tags | map |
| vpn_authentication_types | VPN authentication types | list(string) |
| virtual_hub_id | virtual_hub_id to attach the gateway | string |
| address_prefixes | address_prefixes | list(string) |


# Optional/Advance Parameters
Reference for vpn server configuration resource provider: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/vpn_server_configuration

Reference for p2s vpn gateway: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/point_to_site_vpn_gateway

| Parameter Name | Description | Default Value | Type | 
|---|---|---|---|
| vpn_protocols | VPN portocols to be used | null | list(string) |
| ipsec_policy | route block, refer vpn_server_configuration resource provider for usage | null | object({<br/>dh_group = string<br/>ike_encryption = string<br/>ike_integrity = string<br/>ipsec_encryption = string<br/>ipsec_integrity = string<br/>pfs_group = string<br/>sa_lifetime_seconds = number<br/>sa_data_size_kilobytes = number<br/>}) |
| azure_active_directory_authentication | azure_active_directory_authentication block, refer vpn_server_configuration resource provider for usage | null | object({<br/>audience = string<br/>issuer = string<br/>tenant = string<br/>}) |
| client_root_certificates | client_root_certificate block, refer vpn_server_configuration resource provider for usage | null | list(object({<br/>name = string<br/>public_cert_data = string<br/>})) |
| client_revoked_certificates | client_revoked_certificate block, refer vpn_server_configuration resource provider for usage | null | list(object({<br/>name = string<br/>thumbprint = string<br/>})) |
| radius_client_root_certificates | radius client_revoked_certificate block, refer vpn_server_configuration resource provider for usage | null | list(object({<br/>name = string<br/>thumbprint = string<br/>})) |
| radius_server_root_certificates | radius server_root_certificate block, refer vpn_server_configuration resource provider for usage | null | list(object({<br/>name = string<br/>public_cert_data = string<br/>})) |
| radius_servers| raduis server block, refer vpn_server_configuration resource provider for usage | null | list(object({<br/>address = string<br/>secret = string<br/>score = number<br/>})) |
| scale_unit | refer point_to_site_vpn_gateway resource provider for usage | 1 | number |
| dns_servers | refer point_to_site_vpn_gateway resource provider for usage | null | list(string) |
| internet_security_enabled | refer to connection_configuration block point_to_site_vpn_gateway resource provider for usage | null | string |
| associated_route_table_id | refer to connection_configuration block point_to_site_vpn_gateway resource provider for usage | null | string |
| propagated_route_table | refer to connection_configuration block point_to_site_vpn_gateway resource provider for usage | null | object({<br/>ids = list(string)<br/>labels = list(string)<br/>}) |

# Outputs

| Parameter Name | Description | Type | 
|---|---|---|
| p2sgw_out | Output of the p2s gateway | any |
| vpnconfig_out | Output of the vpn server config | any |

# Additional details
## Simple code sample
```
module "vpnp2s" {
  source                       = "git::https://dev.azure.com/FY22-Asset-build-funding/Sovereign%20MS%20with%20Adelaide%20Hub%20Delivery%20Model/_git/Terraform-Modules//VPNGatewayP2S"
  name         = "vpnp2s"
  location     = "Australia East"
  resource_group_name           = azurerm_resource_group.avatest.name
  vpn_authentication_types = ["Certificate"]
  address_prefixes = ["12.0.0.0/24"]
  tags         = {
    environment = "sandbox"
  }
  virtual_hub_id = module.hub.hub_out.id
  client_root_certificates = [{
    name             = "DigiCert-Federated-ID-Root-CA"
    public_cert_data = <<EOF
MIIDuzCCAqOgAwIBAgIQCHTZWCM+IlfFIRXIvyKSrjANBgkqhkiG9w0BAQsFADBn
MQswCQYDVQQGEwJVUzEVMBMGA1UEChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3
d3cuZGlnaWNlcnQuY29tMSYwJAYDVQQDEx1EaWdpQ2VydCBGZWRlcmF0ZWQgSUQg
Um9vdCBDQTAeFw0xMzAxMTUxMjAwMDBaFw0zMzAxMTUxMjAwMDBaMGcxCzAJBgNV
BAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdp
Y2VydC5jb20xJjAkBgNVBAMTHURpZ2lDZXJ0IEZlZGVyYXRlZCBJRCBSb290IENB
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvAEB4pcCqnNNOWE6Ur5j
QPUH+1y1F9KdHTRSza6k5iDlXq1kGS1qAkuKtw9JsiNRrjltmFnzMZRBbX8Tlfl8
zAhBmb6dDduDGED01kBsTkgywYPxXVTKec0WxYEEF0oMn4wSYNl0lt2eJAKHXjNf
GTwiibdP8CUR2ghSM2sUTI8Nt1Omfc4SMHhGhYD64uJMbX98THQ/4LMGuYegou+d
GTiahfHtjn7AboSEknwAMJHCh5RlYZZ6B1O4QbKJ+34Q0eKgnI3X6Vc9u0zf6DH8
Dk+4zQDYRRTqTnVO3VT8jzqDlCRuNtq6YvryOWN74/dq8LQhUnXHvFyrsdMaE1X2
DwIDAQABo2MwYTAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBhjAdBgNV
HQ4EFgQUGRdkFnbGt1EWjKwbUne+5OaZvRYwHwYDVR0jBBgwFoAUGRdkFnbGt1EW
jKwbUne+5OaZvRYwDQYJKoZIhvcNAQELBQADggEBAHcqsHkrjpESqfuVTRiptJfP
9JbdtWqRTmOf6uJi2c8YVqI6XlKXsD8C1dUUaaHKLUJzvKiazibVuBwMIT84AyqR
QELn3e0BtgEymEygMU569b01ZPxoFSnNXc7qDZBDef8WfqAV/sxkTi8L9BkmFYfL
uGLOhRJOFprPdoDIUBB+tmCl3oDcBy3vnUeOEioz8zAkprcb3GHwHAK+vHmmfgcn
WsfMLH4JCLa/tRYL+Rw/N3ybCkDp00s0WUZ+AoDywSl0Q/ZEnNY0MsFiw6LyIdbq
M/s/1JRtO3bDSzD9TazRVzn2oBqzSa8VgIo5C1nOnoAKJTlsClJKvIhnRlaLQqk=
EOF
  }]
}
```
## attach a configuration policy group to the vpn server configuration
```
resource "azurerm_vpn_server_configuration_policy_group" "example" {
  name                        = "example-VPNSCPG"
  vpn_server_configuration_id = module.vpnp2s.vpnconfig_out.id

  policy {
    name  = "policy1"
    type  = "RadiusAzureGroupId"
    value = "6ad1bd08"
  }
}
```
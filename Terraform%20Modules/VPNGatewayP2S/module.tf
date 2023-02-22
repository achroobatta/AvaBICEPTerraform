#create vpn server config

resource "azurerm_vpn_server_configuration" "vpnserverconfig" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  vpn_authentication_types = var.vpn_authentication_types
  vpn_protocols =  var.vpn_protocols
  tags = var.tags
  #dynamic block for ipsec
  dynamic "ipsec_policy"{
    for_each = var.ipsec_policy != null ? [true]: []
    content{
      dh_group = var.ipsec_policy.dh_group
      ike_encryption = var.ipsec_policy.ike_encryption
      ike_integrity = var.ipsec_policy.ike_integrity
      ipsec_encryption = var.ipsec_policy.ipsec_encryption
      ipsec_integrity = var.ipsec_policy.ipsec_integrity
      pfs_group = var.ipsec_policy.pfs_group
      sa_lifetime_seconds = var.ipsec_policy.sa_lifetime_seconds
      sa_data_size_kilobytes = var.ipsec_policy.sa_data_size_kilobytes
    }
  }
  #dynamic block for azure_active_directory_authentication
  dynamic "azure_active_directory_authentication"{
    for_each = var.azure_active_directory_authentication != null ? [true]: []
    content{
      audience = var.azure_active_directory_authentication.audience
      issuer = var.azure_active_directory_authentication.issuer
      tenant = var.azure_active_directory_authentication.tenant
    }
  }
  #dynamic block for client_root_certificate
  dynamic "client_root_certificate"{
    for_each = var.client_root_certificates != null ? var.client_root_certificates: []
    content{
      name = client_root_certificate.value.name
      public_cert_data = client_root_certificate.value.public_cert_data
    }
  }
  #dynamic block for client_revoked_certification
  dynamic "client_revoked_certificate"{
    for_each = var.client_revoked_certificates != null ? var.client_revoked_certificates: []
    content{
      name = client_revoked_certificate.value.name
      thumbprint = client_revoked_certificate.value.thumbprint
    }
  }

  #nested dynamic block for radius
  dynamic "radius"{
    #check for radius_servers variable to create a single radius block or not
    for_each = var.radius_servers != null ? [true]: []
    content{
      dynamic "server"{
        #create multiple nested server block based on number of objects in variable
        for_each = var.radius_servers != null ? var.radius_servers: []
        content {
          address = server.value.address
          secret = server.value.secret
          score = server.value.score
        }
      }
      dynamic "client_root_certificate"{
        #create multiple nested client_root_ceritificate block based on number of objects in variable
        for_each = var.radius_client_root_certificates != null ? var.radius_client_root_certificates: []
        content {
          name = client_root_ceritificate.value.name
          thumbprint = client_root_ceritificate.value.thumbprint
        }
      }
      dynamic "server_root_certificate"{
        #create multiple nested client_root_ceritificate block based on number of objects in variable
        for_each = var.radius_server_root_certificates != null ? var.radius_server_root_certificates: []
        content {
          name = server_root_ceritificate.value.name
          public_cert_data = server_root_certificate.value.public_cert_data
        }
      }
    }
  }
}

#create vpn gateway based on server config
resource "azurerm_point_to_site_vpn_gateway" "p2sgw" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  virtual_hub_id              = var.virtual_hub_id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.vpnserverconfig.id
  scale_unit                  = var.scale_unit
  tags = var.tags
  connection_configuration {
    name = "terraform-managed-config"
    internet_security_enabled = var.internet_security_enabled
    vpn_client_address_pool {
      address_prefixes = var.address_prefixes
    }
    #dynamic block route based on var.associated_route_table_id existance
    dynamic "route"{
      for_each = var.associated_route_table_id != null ? [true]: []
      content{
        associated_route_table_id = var.associated_route_table_id
        #nested dynamic block based on var.propagated_route_table existence
        dynamic "propagated_route_table"{
          for_each = var.propagated_route_table != null ? [true]: []
          content{
            ids = var.propagated_route_table.ids
            labels = var.propagated_route_table.labels
          }
        }
      }
    }
  }
}
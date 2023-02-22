#************************** Public IP Variables *************************
variable "public_ip_name" {
  description = "(Required) Name of the public IP"
  type        = string
}
variable "resource_group_name" {
  description = "(Required) Name of the resource group"
  type        = string
}
variable "location" {
  description = "(Required) Name of the location"
  type        = string
}
variable "allocation_method" {
  description = "(Required) Defines the allocation method for this IP address. Possible values are Static or Dynamic."
  type        = string
}

variable "public_ip_sku" {
  description = "(Required) SKU of the public IP"
  type        = string
}

#************************ Application Gateway Variables *******************************

variable "application_gateway_name" {
  description = "(Required) Name of the application gateway"
  type        = string
}
variable "enable_http2" {
  description = "(Optional) Is HTTP2 enabled on the application gateway resource?"
  default     = false
  type        = bool
}
variable "fips_enabled" {
  description = "(Optional) Is FIPS enabled on the Application Gateway?"
  default     = false
  type        = bool
}
variable "force_firewall_policy_association" {
  description = "(Optional) Is the Firewall Policy associated with the Application Gateway?"
  default     = false
  type        = bool
}
variable "firewall_policy_id" {
  description = "The ID of the Web Application Firewall Policy which can be associated with app gateway"
  default     = null
  type        = string
} 
variable "tags" {
  description = "(Required) A map of tags"
  type        = map(string)
}
variable "sku" {
  description = "(Required) The sku pricing model"
  type = object({
    name     = string
    tier     = string
    capacity = number
  })
}
variable "autoscale_configuration" {
  description = "(Optional) Minimum or Maximum capacity for autoscaling. Accepted values are for Minimum in the range 0 to 100 and for Maximum in the range 2 to 125"
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}
variable "frontend_http_port" {
  description = "(Required) Frontend port used to listen for HTTP traffic"
  type        = number
  default     = 80
}
variable "frontend_https_port" {
  description = "(Required) Frontend port used to listen for HTTPS traffic"
  type        = number
  default     = 443
}
variable "subnet_id" {
  description = "(Required) The ID of the Subnet which the Application Gateway should be connected to"
  type        = string
}
variable "backend_address_pools" {
  description = "(Required) List of backend address pools."
  type = list(object({
    name         = string
    ip_addresses = list(string)
    fqdns        = list(string)
  }))
}
variable "backend_http_settings" {
  description = "List of backend HTTP settings."
  type = list(object({
    name                                = string
    path                                = string
    port                                = number
    protocol                            = string
    enable_cookie_based_affinity        = bool
    request_timeout                     = number
    probe_name                          = string
    host_name                           = string
    pick_host_name_from_backend_address = bool
  }))
}
variable "authentication_certificate" {
  description = "(optional) list application gateway authentication certificate"
  default     = []
}
variable "trusted_root_certificate_names" {
  description = "(Optional) A list of trusted_root_certificate names"
  type        = list(string)
  default     = []
}
variable "connection_draining" {
  description = "(Optional) connection draining"
  type        = object({
    enabled   = bool
    drain_timeout_sec = number
  })
  default  = null
}
variable "custom_error_configuration" {
  description = "(Optional) custom error configuration"
  type        = object({
    status_code           = string //Possible values are HttpStatus403 and HttpStatus502
    custom_error_page_url = string
  })
  default = null
}
variable "http_listeners" {
  description = "List of HTTP/HTTPS listeners. HTTPS listeners require an SSL Certificate object."
  type = list(object({
    name                 = string
    ssl_certificate_name = string
    host_name            = string
    host_names           = list(string)
    require_sni          = bool
  }))
}
variable "identity_ids" {
  description = "(Optional) Specifies a list with a single user managed identity id to be assigned to the Application Gateway"
  default     = null
  type        = list(string)
}
# Routing can be any of the three types: basic, redirect and pathbased.
variable "basic_request_routing_rules" {
  description = "(Required) Request routing rules to be used for listeners."
  type = list(object({
    name                        = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    rewrite_rule_set_name = string
    priority                    = number
  }))
  default = []
}
variable "redirect_request_routing_rules" {
  description = "(Required) Request routing rules to be used for listeners."
  type = list(object({
    name                        = string
    http_listener_name          = string
    redirect_configuration_name = string
    rewrite_rule_set_name = string
    priority                    = number
  }))
  default = []
}
variable "path_based_request_routing_rules" {
  description = "(Required) Path based request routing rules to be used for listeners."
  type = list(object({
    name               = string
    http_listener_name = string
    url_path_map_name  = string
  }))
  default = []
}
variable "probes" {
  description = "(Optional) Health probes used to test backend health."
  default     = []
  type = list(object({
    name                                      = string
    host                                      = string
    path                                      = string
    protocol                                  = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = number
    minimum_servers                           = number
    match_body                                = string
    match_status_codes                        = list(string)
    pick_host_name_from_backend_http_settings = bool
  }))
}
variable "ssl_certificates" {
  description = "(Optional) List of SSL Certificates to attach to the application gateway."
  type = list(object({
    name                = string
    pfx_data            = string
    pfx_password        = string
    key_vault_secret_id = string
  }))
  default = []
}
variable "ssl_policy" {
  description = "(Optional) define TLS settings if required"
  type = object({
    disabled_protocols = list(string)
    policy_type = string
    policy_name = string
    cipher_suites = list(string)
    min_protocol_version = string
  })
  default = null
}

### REWRITE RULE SET

variable "rewrite_rule_sets" {
  description = "List of rewrite rule set objects with rewrite rules."
  type = list(object({
    name = string
    rewrite_rules = list(object({
      name          = string
      rule_sequence = string

      conditions = optional(list(object({
        variable    = string
        pattern     = string
        ignore_case = optional(bool, false)
        negate      = optional(bool, false)
      })), [])

      response_header_configurations = optional(list(object({
        header_name  = string
        header_value = string
      })), [])

      request_header_configurations = optional(list(object({
        header_name  = string
        header_value = string
      })), [])

      url = optional(object({
        path         = optional(string)
        query_string = optional(string)
        components   = optional(string)
        reroute      = optional(bool)
      }))
    }))
  }))
  default = []
}

#*************************** Azure Monitor Onboarding ***********************************
variable "logging_retention" {
  description = "(Optional) Retention period of azure_monitor configuration"
  default = 30
  type    = number
}
variable "azure_monitor" {
  description = "(Required) Azure Monitor module output to configure monitoring"
  default = null
}
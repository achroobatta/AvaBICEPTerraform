locals {
  http_frontend_port_name         = "${var.application_gateway_name}-http-port"
  https_frontend_port_name        = "${var.application_gateway_name}-https-port"
  frontend_ip_configuration_name  = "${var.application_gateway_name}-feip"
  http_listener_name              = "${var.application_gateway_name}-httplstn"
  https_listener_name             = "${var.application_gateway_name}-httpslstn"
  http_request_routing_rule_name  = "${var.application_gateway_name}-http-rqrt"
  https_request_routing_rule_name = "${var.application_gateway_name}-https-rqrt"
  http_setting_name               = "${var.application_gateway_name}-be-http-st"
  redirect_configuration_name     = "${var.application_gateway_name}-rdrcfg"
}
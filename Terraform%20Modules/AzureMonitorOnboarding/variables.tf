variable "resource_name" {
  description = "(Required) Name of the resource"
  type        = string
}

variable "resource_id" {
  description = "(Required) ID of the resource"
  type        = string
}

#Optional variables###############################################################################
variable "log_analytics_workspace_id" {
  description = "(Optional) The ID of the Log Analytics Workspace which the OMS Agent should send data to."
  default     = null
}

variable "diagnostics_logs_map" {
  description = "(Optional) Send the logs generated to diagnostics"
  default = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      #["kube-apiserver", true, 30],
    ]
    metric = [
      #["Category name", "Retention Enabled", Retention period] 
      #["AllMetrics", true, 30],
    ]
  }
}

variable "diagnostics_map" {
  description = "(Optional) Storage Account and Event Hub data for the diagnostics"
  default = {
    diags_sa = null
    eh_id    = ""
    eh_name  = null
  }
}

variable "log_analytics_workspace_dedicated" {
  description = "(Optional) Set to Dedicated for logs to be sent into resource specific tables instead of AzureDiagnostics table"
  default     = null
}

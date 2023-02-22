#Manages an Azure Data Factory (Version 2)
resource "azurerm_data_factory" "df" {
  name                              = var.data_factory_name
  location                          = var.location
  resource_group_name               = var.resource_group_name
  tags                              = var.tags 
  managed_virtual_network_enabled   = var.managed_virtual_network_enabled
  public_network_enabled            = var.public_network_enabled
  customer_managed_key_id           = var.customer_managed_key_id
  customer_managed_key_identity_id  = var.customer_managed_key_id != null ? var.customer_managed_key_identity_id : null
  dynamic "github_configuration" { 
    for_each = var.github_configuration != null ? ["true"] : []
    content {
        account_name    = var.github_configuration.account_name
        branch_name     = var.github_configuration.branch_name
        git_url         = var.github_configuration.git_url
        repository_name = var.github_configuration.repository_name
        root_folder     = var.github_configuration.root_folder
    }
  }
  // Note: You must log in to the Data Factory management UI to complete the authentication to the GitHub repository
  dynamic "global_parameter" {
    for_each = var.global_parameter != null ? ["true"] : []
    content {
      name = var.global_parameter.name
      type = var.global_parameter.type
      value = var.global_parameter.value
    }
  }
  dynamic "identity" {
    for_each = var.managed_identity_type != null ? ["true"] : []
    content {
      type         = var.managed_identity_type
      identity_ids = var.managed_identity_type == "UserAssigned" || var.managed_identity_type == "SystemAssigned, UserAssigned" ? var.managed_identity_ids : null
    }
  }
  dynamic "vsts_configuration" {
    for_each = var.vsts_configuration != null ? ["true"] : []
    content {
      account_name    = var.vsts_configuration.account_name
      branch_name     = var.vsts_configuration.branch_name
      project_name    = var.vsts_configuration.project_name
      repository_name = var.vsts_configuration.repository_name
      root_folder     = var.vsts_configuration.root_folder
      tenant_id       = var.vsts_configuration.tenant_id
    }
  }
}

#**************************** Azure Data Factory Managed Endpoint ***************************************
resource "azurerm_data_factory_managed_private_endpoint" "example" {
  count              = var.private_endpoint_required ? 1 : 0 
  name               = var.private_endpoint_name
  data_factory_id    = azurerm_data_factory.df.id
  target_resource_id = var.target_resource_id
  subresource_name   = var.subresource_name
  fqdns              = var.fqdns
}


#**************************** Azure Data Factory Pipeline ***********************************************
resource "azurerm_data_factory_pipeline" "pipeline" {
  count = var.pipeline_required ? 1 : 0 
  name            = var.pipeline_name
  data_factory_id = azurerm_data_factory.df.id
  description     = var.pipeline_description
  annotations     = var.pipeline_annotations
  concurrency     = var.pipeline_concurrency
  folder          = var.pipeline_folder
  moniter_metrics_after_duration = var.pipeline_moniter_metrics_after_duration
  parameters      = var.pipeline_parameters
  variables       = var.pipeline_variables
  activities_json = var.pipeline_activities_json 
}

#******************************* Azure Monitor Onboarding **************************
module "datafactory_diag" {
  count = var.azure_monitor != null ? 1 : 0
  source                     = "../AzureMonitorOnboarding/"
  resource_name              = var.data_factory_name
  resource_id                = azurerm_data_factory.df.id
  log_analytics_workspace_id = var.azure_monitor.law_out.id
  diagnostics_logs_map = {
    log = [
      #["Category name", "Retention Enabled", Retention period] 
      ["ActivityRuns", true, var.logging_retention],
      ["PipelineRuns",true, var.logging_retention],
      ["SSISIntegrationRuntimeLogs", true, var.logging_retention],
      ["SSISPackageEventMessageContext", true, var.logging_retention],
      ["SSISPackageEventMessages", true, var.logging_retention],
      ["SSISPackageExecutableStatistics", true, var.logging_retention],
      ["SSISPackageExecutionComponentPhases", true, var.logging_retention],
      ["SSISPackageExecutionDataStatistics", true, var.logging_retention],
      ["SandboxActivityRuns", true, var.logging_retention],
      ["SandboxPipelineRuns", true, var.logging_retention],
                 
    ]
    metric = [
      ["AllMetrics", true, var.logging_retention],
    ]
  }
  diagnostics_map = {
    diags_sa = length(var.azure_monitor.sa_out) > 0 ? var.azure_monitor.sa_out[0].id : null
    eh_id    = length(var.azure_monitor.ehnamespace_out) > 0 ? var.azure_monitor.ehnamespace_out[0].id : null
    eh_name  = length(var.azure_monitor.eh_out) > 0 ? var.azure_monitor.eh_out[0].name : null
  }
}



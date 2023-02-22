There is no PrivateEndPoint module, use the resource provider directly. https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint

# Sample code to attach blob pep to storage account and subnet created by our module
```
resource "azurerm_private_endpoint" "example" {
  name                = "example-endpoint"
  location            = "Australia East"
  resource_group_name = azurerm_resource_group.avatest.name
  subnet_id           = module.vnetmodule.subnets_out[0].id

  private_service_connection {
    name                              = "example-privateserviceconnection"
    private_connection_resource_id = module.azure_storageaccount.sa_out.id
    is_manual_connection              = false
    subresource_names = ["blob"]
  }
}
```
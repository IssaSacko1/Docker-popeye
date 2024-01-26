data "azurerm_service_plan" "this" {
  name                = "docker-popeye-asp-production"
  resource_group_name = var.resource_group_name
}


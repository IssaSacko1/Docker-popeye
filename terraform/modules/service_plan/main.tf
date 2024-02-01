data "azurerm_service_plan" "this" {
  name                = "docker-popeye-asp-prod"
  resource_group_name = var.resource_group_name
}


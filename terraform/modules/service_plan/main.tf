resource "azurerm_service_plan" "service_plan_development" {
  name                = "docker-popeye-asp-development"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  os_type  = "Linux"
  sku_name = "F1"
}


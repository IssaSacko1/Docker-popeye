resource "azurerm_service_plan" "service_plan_test" {
  name                = "docker-popeye-asp-test"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  os_type  = "Linux"
  sku_name = "F1"
}


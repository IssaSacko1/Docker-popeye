resource "azurerm_service_plan" "this" {
  name                = "docker-popeye-asp-production"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  os_type  = "Linux"
  sku_name = "F1"
}


# Créer un espace de travail Log Analytics
module "web_app" {
  source              = "../web_app"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "storage_account" {
  source              = "../storage_account"
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account_name= var.storage_account_name
}
data "azurerm_log_analytics_workspace" "example" {
  name                = "example-log-analytics-workspace"
  resource_group_name = var.resource_group_name
}

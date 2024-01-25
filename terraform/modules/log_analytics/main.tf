# Créer un espace de travail Log Analytics
resource "azurerm_log_analytics_workspace" "example" {
  name                = "example-log-analytics-workspace"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Configurer la collecte de logs pour l'application web
resource "azurerm_monitor_diagnostic_setting" "example" {
  name         = "example-diagnostic-settings"
  target_resource_id = module.web_app.web_app_id
  storage_account_id = module.storage_account.storage_account_id

  enabled_log {
    category = "AppServiceHTTPLogs"

    retention_policy {
      enabled = true
      days    = 30
    }
  }

  enabled_log {
    category = "AppServiceConsoleLogs"

    retention_policy {
      enabled = true
      days    = 30
    }
  }
}
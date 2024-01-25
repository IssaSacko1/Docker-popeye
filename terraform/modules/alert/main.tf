resource "azurerm_monitor_action_group" "email_action_group" {
  name                      = "email-action-group"
  short_name                = "exampleact"
  resource_group_name = var.resource_group_name

  email_receiver {
    name          = "email-receiver"
    email_address = "issa.sacko1@gmail.com"
  }
}

# Créer une alerte pour le taux de réponse HTTP
resource "azurerm_monitor_metric_alert" "http_response_rate_alert" {
  name                = "http-response-rate-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_linux_web_app.docker-popeye-app-terraform.id]

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1000  # Exemple de seuil à ajuster
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_action_group.id
  }
}

resource "azurerm_monitor_metric_alert" "http_response_time_alert" {
  name                = "response-time-alert"
  resource_group_name = var.resource_group_name
  scopes              = [azurerm_linux_web_app.docker-popeye-app-terraform.id]

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "AverageResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1000  # Exemple de seuil à ajuster
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_action_group.id
  }
}
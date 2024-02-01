module "web_app" {
  source              = "../web_app"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_monitor_action_group" "email_action_group_development" {
  name                      = "email-action-group-development"
  short_name                = "exampleact"
  resource_group_name = var.resource_group_name

  email_receiver {
    name          = "email-receiver"
    email_address = "issa.sacko1@gmail.com"
  }
}


# Créer une alerte pour le taux de réponse HTTP
resource "azurerm_monitor_metric_alert" "http_response_rate_alert-development" {
  name                = "http-response-rate-alert-development"
  resource_group_name = var.resource_group_name
  scopes              = [module.web_app.web_app_id]

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Requests"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1000  # Exemple de seuil à ajuster
  }

  action {
    action_group_id = azurerm_monitor_action_group.email_action_group_development.id
  }
}

resource "azurerm_monitor_metric_alert" "http_response_time_alert_development" {
  name                = "response-time-alert-develop"
  resource_group_name = var.resource_group_name
  scopes              = [module.web_app.web_app_id]

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "AverageResponseTime"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 1000  # Exemple de seuil à ajuster
  }

  action {
    action_group_id = azurerm_monitor_action_group.develop.id
  }
}
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.75.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 1.7"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "7d107c3a-8cb7-42a7-9ddb-25f365ae19e2"
}

# provider "azapi" {}

######################################
# Variables

variable "resource_group_name" {
  type = string
  default = "T-cloud-3"
}

variable "location" {
  type    = string
  default = "West Europe"
}

variable "tags" {
  description = "Tags to apply on any resource within this project"
  type        = map(string)
  default = {
    deploymentMethod = "terraform"
  }
}


#######################################
# Resources

data "azurerm_resource_group" "T-cloud-3" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "sadockerpopeye901" {
  name                     = "sadockerpopeye901"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "this" {
  name                = "docker-popeye-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  os_type  = "Linux"
  sku_name = "F1"
}


resource "azurerm_linux_web_app" "docker-popeye-app-terraform" {
  name                = "docker-popeye-app-terraform"
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id = azurerm_service_plan.this.id
  app_settings = {}

  site_config {
    always_on = false
  }

  logs {
    application_logs {
        file_system_level = "Error"
    }
    
    http_logs {
      file_system {
        retention_in_days = 7
        retention_in_mb   = 100
      }
    }
 }
}

# App Service Resource currently doesn't support to set docker compose
# See: https://github.com/hashicorp/terraform-provider-azurerm/issues/16290
resource "azapi_update_resource" "update_linux_web_app" {
  resource_id = azurerm_linux_web_app.docker-popeye-app-terraform.id
  type        = "Microsoft.Web/sites@2022-03-01"
  body = jsonencode({
    properties = {
      siteConfig = {
        linuxFxVersion = "COMPOSE|${base64encode(file("./docker-compose.yml"))}"
      }
    }
  })
}

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
  target_resource_id = azurerm_linux_web_app.docker-popeye-app-terraform.id
  storage_account_id = azurerm_storage_account.sadockerpopeye901.id

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

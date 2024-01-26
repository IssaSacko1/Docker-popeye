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

module "service_plan" {
  source              = "../service_plan"
  resource_group_name = var.resource_group_name
  location            = var.location
}

resource "azurerm_linux_web_app" "docker-popeye-app-production" {
  name                = "docker-popeye-app-production"
  resource_group_name = var.resource_group_name
  location            = var.location

  service_plan_id = module.service_plan.service_plan_id
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
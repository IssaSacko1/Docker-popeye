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

data "azurerm_linux_web_app" "docker-popeye-app-production" {
  name                = "docker-popeye-app-production"
  resource_group_name = var.resource_group_name
}

# App Service Resource currently doesn't support to set docker compose
# See: https://github.com/hashicorp/terraform-provider-azurerm/issues/16290
resource "azapi_update_resource" "update_linux_web_app" {
  resource_id = data.azurerm_linux_web_app.docker-popeye-app-production.id
  type        = "Microsoft.Web/sites@2022-03-01"
  body = jsonencode({
    properties = {
      siteConfig = {
        linuxFxVersion = "COMPOSE|${base64encode(file("./docker-compose.yml"))}"
      }
    }
  })
}
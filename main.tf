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

resource "azurerm_service_plan" "this" {
  name                = "docker-popeye-asp"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  os_type  = "Linux"
  sku_name = "F1" #! Change me
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
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

data "azurerm_resource_group" "T-CLO-ISA-test-environment" {
  name     = var.resource_group_name
}

module "storage_account" {
  source              = "./modules/storage_account"
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account_name = var.storage_account_name
}

module "service_plan" {
  source              = "./modules/service_plan"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags
}

module "web_app" {
  source              = "./modules/web_app"
  resource_group_name = var.resource_group_name
  location            = var.location
}

# module "log_analytics" {
#  source              = "./modules/log_analytics"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  storage_account_name = var.storage_account_name
#}

module "alert" {
  source              = "./modules/alert"
  resource_group_name = var.resource_group_name
  location            = var.location
}


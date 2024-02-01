resource "azurerm_storage_account" "sadockerpopeye901prod" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "sadockerpopeye901" {
  resource_group_name = "T-CLO-ISA-test-environment"
  name = "sadockerpopeye901"
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
       lifecycle {
    ignore_changes = all
}
}
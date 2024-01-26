# modules/storage_account/outputs.tf

output "storage_account_id" {
  value = data.azurerm_storage_account.sadockerpopeye901.id
}

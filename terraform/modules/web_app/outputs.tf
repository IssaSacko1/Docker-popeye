# modules/web_app/outputs.tf

output "web_app_id" {
  value = azurerm_linux_web_app.docker-popeye-app-terraform.id
}

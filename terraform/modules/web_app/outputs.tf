# modules/web_app/outputs.tf

output "web_app_id" {
  value = data.azurerm_linux_web_app.docker-popeye-app-production.id
}

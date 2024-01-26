# modules/service_plan/outputs.tf

output "service_plan_id" {
  value = data.azurerm_service_plan.this.id
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type    = string
}

variable "tags" {
  description = "Tags to apply on any resource within this project"
  type        = map(string)
  default = {
    deploymentMethod = "terraform"
  }
}

variable "storage_account_name" {
  type    = string
}
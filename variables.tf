variable "azure_subscription_id" {}
variable "azure_client_id" {}
variable "azure_client_secret" {}
variable "azure_tenant_id" {}

variable "resource_group" {
  default = "devops-rg"
}

variable "location" {
  default = "East US"
}

variable "aks_name" {
  default = "devops-aks"
}

variable "acr_name" {
  default = "devopsacr"
}


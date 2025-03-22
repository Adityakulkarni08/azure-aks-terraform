terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.6.0"
}

# Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group
  location = var.location
}

# Generate a unique suffix for ACR name
resource "random_string" "acr_suffix" {
  length  = 6
  special = false
  upper   = false
}

# Create an Azure Kubernetes Service (AKS) Cluster (Free Tier)
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "devops"

  default_node_pool {
    name       = "default"
    node_count = 1  # Keep it 1 to stay within Free Tier
    vm_size    = "Standard_B2s"  # Smallest VM for Free Tier
  }

  identity {
    type = "SystemAssigned"
  }

  # Use the latest supported Kubernetes version
  kubernetes_version = "1.31.6"
}

# Create an Azure Container Registry (ACR) (Free Tier)
resource "azurerm_container_registry" "acr" {
  name                = "devopsacr${random_string.acr_suffix.result}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"  # Free Tier supports Basic SKU
  admin_enabled       = true
}


# Resource Group principal pour toutes les ressources
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Resource Group pour le stockage de l'état Terraform
resource "azurerm_resource_group" "terraform_state" {
  name     = "rg-terraform-state"
  location = var.location
  tags = merge(local.common_tags, {
    Purpose = "Terraform State Storage"
  })
}

# Compte de stockage pour l'état Terraform
resource "azurerm_storage_account" "terraform_state" {
  name                     = "stterraformstatebackendf1763c7b"
  resource_group_name      = azurerm_resource_group.terraform_state.name
  location                 = azurerm_resource_group.terraform_state.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # Sécurité
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  
  tags = merge(local.common_tags, {
    Purpose = "Terraform State Storage"
  })
}

# Container pour l'état Terraform
resource "azurerm_storage_container" "terraform_state" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.terraform_state.name
  container_access_type = "private"
}

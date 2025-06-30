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

# Note: Le Storage Account et le Container pour le state Terraform
# sont gérés par le script init-backend.sh et non par Terraform
# pour éviter les problèmes de "chicken and egg" avec le backend.

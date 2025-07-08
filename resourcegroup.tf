# Resource Group principal pour toutes les ressources
resource "azurerm_resource_group" "main" {
  name     = local.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Note: Le Storage Account et le Container pour le state Terraform
# sont gérés par le script init-backend.sh et non par Terraform
# pour éviter les problèmes de "chicken and egg" avec le backend.

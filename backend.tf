# Configuration du backend Terraform pour stocker l'état dans Azure Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstatebackend"
    container_name       = "tfstate"
    # key sera passé dynamiquement par -backend-config
  }
}
    # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
    # Remplacer ${ENVIRONMENT} par la variable d'environnement ou le workspace Terraform
    # Par exemple, lancez terraform avec: ENVIRONMENT=staging terraform init

# Configuration du backend Terraform pour stocker l'état dans Azure Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstatebackendf1763c7b"
    container_name       = "tfstate"
    key                  = "devops-cicd.terraform.tfstate"
    
    # Ces valeurs peuvent être définies via les variables d'environnement :
    # ARM_CLIENT_ID, ARM_CLIENT_SECRET, ARM_SUBSCRIPTION_ID, ARM_TENANT_ID
  }
}

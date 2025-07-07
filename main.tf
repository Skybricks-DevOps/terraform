# Configuration du provider et des ressources principales
terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.70"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Configuration du provider Azure
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Génération d'un ID aléatoire pour les ressources qui nécessitent un nom unique
resource "random_id" "main" {
  byte_length = 4
}

# Obtenir les informations du client actuel
data "azurerm_client_config" "current" {}

# Variables locales pour standardiser les noms
locals {
  project_name = "devops-cicd"
  environment  = var.environment
  
  # Tags communs à appliquer sur toutes les ressources
  common_tags = {
    Project     = local.project_name
    Environment = local.environment
    ManagedBy   = "Terraform"
    Owner       = var.owner
    Repository  = var.github_repository
  }

  # Noms standardisés des ressources
  resource_group_name     = "rg-${local.project_name}-${local.environment}"
  aks_cluster_name       = "aks-${local.project_name}-${local.environment}-${random_id.main.hex}"
  key_vault_name         = "kv${local.environment}${random_id.main.hex}"
  postgresql_server_name = "psql-${local.project_name}-${local.environment}-${random_id.main.hex}"
  log_analytics_name     = "log-${local.project_name}-${local.environment}-${random_id.main.hex}"
}

// Pas de changement, la logique locale gère déjà l'environnement via var.environment
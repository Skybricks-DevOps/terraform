# Outputs essentiels pour le déploiement Helm et l'intégration

# Resource Group
output "resource_group_name" {
  description = "Nom du resource group principal"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Localisation du resource group"
  value       = azurerm_resource_group.main.location
}

# AKS Cluster - Critiques pour Helm
output "aks_cluster_name" {
  description = "Nom du cluster AKS"
  value       = azurerm_kubernetes_cluster.main.name
}

output "aks_cluster_id" {
  description = "ID du cluster AKS"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_cluster_fqdn" {
  description = "FQDN du cluster AKS"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "aks_kubeconfig" {
  description = "Configuration kubectl pour se connecter au cluster AKS"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "aks_host" {
  description = "Host du cluster AKS pour Helm"
  value       = azurerm_kubernetes_cluster.main.kube_config.0.host
  sensitive   = true
}

output "aks_client_certificate" {
  description = "Certificat client AKS pour Helm"
  value       = azurerm_kubernetes_cluster.main.kube_config.0.client_certificate
  sensitive   = true
}

output "aks_client_key" {
  description = "Clé client AKS pour Helm"
  value       = azurerm_kubernetes_cluster.main.kube_config.0.client_key
  sensitive   = true
}

output "aks_cluster_ca_certificate" {
  description = "Certificat CA du cluster AKS pour Helm"
  value       = azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate
  sensitive   = true
}

# PostgreSQL - Pour Helm values
output "postgresql_server_name" {
  description = "Nom du serveur PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "postgresql_server_fqdn" {
  description = "FQDN du serveur PostgreSQL pour connexion"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_database_name" {
  description = "Nom de la base de données"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

output "postgresql_admin_username" {
  description = "Nom d'utilisateur admin PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.administrator_login
}

# Key Vault - Pour récupérer les secrets via Helm
output "key_vault_name" {
  description = "Nom du Key Vault"
  value       = azurerm_key_vault.main.name
}

output "key_vault_uri" {
  description = "URI du Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "key_vault_id" {
  description = "ID du Key Vault pour les références"
  value       = azurerm_key_vault.main.id
}

# Réseau - Pour la configuration des services
output "vnet_name" {
  description = "Nom du réseau virtuel"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID du réseau virtuel"
  value       = azurerm_virtual_network.main.id
}

output "aks_subnet_id" {
  description = "ID du subnet AKS"
  value       = azurerm_subnet.aks.id
}

# GitHub Container Registry - Pour Helm image pull secrets
output "github_container_registry" {
  description = "URL du GitHub Container Registry"
  value       = "ghcr.io"
}

output "github_username" {
  description = "Nom d'utilisateur GitHub pour les images"
  value       = var.github_username
}

# Informations pour Helm deployment
output "helm_values" {
  description = "Valeurs pour le déploiement Helm"
  value = {
    # Configuration de l'environnement
    environment = var.environment
    project_name = local.project_name
    
    # Configuration AKS
    aks_cluster_name = azurerm_kubernetes_cluster.main.name
    
    # Configuration PostgreSQL
    database = {
      host     = azurerm_postgresql_flexible_server.main.fqdn
      name     = azurerm_postgresql_flexible_server_database.main.name
      username = azurerm_postgresql_flexible_server.main.administrator_login
      port     = 5432
    }
    
    # Configuration des images
    images = {
      repository = "ghcr.io/${var.github_username}"
      tag        = var.image_tag
      backend    = "backend"
      frontend   = "frontend"
    }
    
    # Configuration Key Vault
    keyVault = {
      name = azurerm_key_vault.main.name
      uri  = azurerm_key_vault.main.vault_uri
    }
    
    # Configuration réseau
    network = {
      vnet_name = azurerm_virtual_network.main.name
      subnet_id = azurerm_subnet.aks.id
    }
  }
  sensitive = false
}

# Instructions de déploiement pour Helm
output "helm_deployment_instructions" {
  description = "Instructions pour déployer avec Helm"
  value = <<-EOT
    # 1. Configuration kubectl
    az aks get-credentials --resource-group ${azurerm_resource_group.main.name} --name ${azurerm_kubernetes_cluster.main.name}
    
    # 2. Vérification du cluster
    kubectl get nodes
    
    # 3. Installation/mise à jour du chart Helm
    helm upgrade --install devops-cicd ./helm-chart \
      --namespace devops-cicd \
      --create-namespace \
      --set database.host=${azurerm_postgresql_flexible_server.main.fqdn} \
      --set database.name=${azurerm_postgresql_flexible_server_database.main.name} \
      --set database.username=${azurerm_postgresql_flexible_server.main.administrator_login} \
      --set images.repository=ghcr.io/${var.github_username} \
      --set images.tag=${var.image_tag} \
      --set keyVault.name=${azurerm_key_vault.main.name}
    
    # 4. Vérification du déploiement
    kubectl get pods -n devops-cicd
    kubectl get services -n devops-cicd
  EOT
}

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

output "postgresql_admin_password" {
  description = "Mot de passe admin PostgreSQL"
  value       = local.postgresql_password
  sensitive   = true
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

# Key Vault - Pour les secrets et certificats
output "key_vault_name" {
  description = "Nom du Key Vault"
  value       = azurerm_key_vault.kv.name
}

output "key_vault_id" {
  description = "ID du Key Vault"
  value       = azurerm_key_vault.kv.id
}

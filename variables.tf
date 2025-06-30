# Variables principales du projet
variable "environment" {
  description = "Environnement de déploiement (dev, staging, prod)"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "L'environnement doit être dev, staging ou prod."
  }
}

variable "location" {
  description = "Région Azure pour déployer les ressources"
  type        = string
  default     = "francecentral"
}

variable "owner" {
  description = "Propriétaire du projet"
  type        = string
  default     = "DevOps Team"
}

variable "github_repository" {
  description = "Repository GitHub du projet"
  type        = string
  default     = "DevOps-CI-CD"
}

# Variables pour AKS
variable "kubernetes_version" {
  description = "Version de Kubernetes pour AKS"
  type        = string
  default     = "1.27.7"
}

variable "aks_node_count" {
  description = "Nombre initial de nœuds AKS"
  type        = number
  default     = 1
}

variable "aks_vm_size" {
  description = "Taille des VMs pour les nœuds AKS"
  type        = string
  default     = "Standard_B2s"
}

# Variables pour PostgreSQL
variable "postgresql_version" {
  description = "Version de PostgreSQL"
  type        = string
  default     = "14"
}

variable "postgresql_sku_name" {
  description = "SKU pour PostgreSQL Flexible Server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgresql_storage_mb" {
  description = "Stockage en MB pour PostgreSQL"
  type        = number
  default     = 32768 # 32GB
}

variable "database_name" {
  description = "Nom de la base de données"
  type        = string
  default     = "employeesdb"
}

variable "db_admin_username" {
  description = "Nom d'utilisateur administrateur de la base de données"
  type        = string
  default     = "dbadmin"
}

# Mot de passe PostgreSQL (sera généré automatiquement si non fourni)
variable "pg_password" {
  description = "Mot de passe administrateur PostgreSQL (laissez vide pour génération automatique)"
  type        = string
  sensitive   = true
  default     = ""
}

# Variables pour les images Docker depuis GitHub Container Registry
variable "github_username" {
  description = "Nom d'utilisateur GitHub"
  type        = string
}

variable "github_token" {
  description = "Token GitHub pour accéder au Container Registry"
  type        = string
  sensitive   = true
}

variable "image_tag" {
  description = "Tag des images Docker à déployer"
  type        = string
  default     = "latest"
}

# Variables réseau
variable "vnet_address_space" {
  description = "Espace d'adressage du réseau virtuel"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "aks_subnet_address_prefixes" {
  description = "Préfixes d'adresse pour le subnet AKS"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "db_subnet_address_prefixes" {
  description = "Préfixes d'adresse pour le subnet de base de données"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

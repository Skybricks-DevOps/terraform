# Terraform - Infrastructure as Code pour Employee Management

Ce dossier contient la configuration **Terraform** pour déployer l'infrastructure Azure de l'application.

---

## Objectifs

- Déployer automatiquement toute l'infrastructure Azure (AKS, PostgreSQL, Key Vault, réseau, etc.)
- Gérer les secrets de façon sécurisée avec Azure Key Vault
- Stocker l'état Terraform à distance dans Azure Storage
- Versionner l'infrastructure et permettre la reproductibilité

---

## Principales ressources déployées

- **Resource Group** principal pour regrouper toutes les ressources Azure
- **AKS (Azure Kubernetes Service)** pour héberger les applications backend et frontend
- **Azure PostgreSQL Flexible Server** pour la base de données des employés
- **Azure Key Vault** pour stocker les secrets (mots de passe DB, tokens, etc.)
- **Azure Storage Account** pour stocker l'état Terraform (`tfstate`) de façon sécurisée
- **Virtual Network & Subnets** pour l'isolation réseau (AKS, DB)
- **Private DNS Zone** pour la résolution interne de PostgreSQL
- **Network Security Groups** pour sécuriser les accès réseau
- **Log Analytics Workspace** pour la supervision AKS

---

## Structure des fichiers

- `main.tf` : Configuration principale, providers, ressources globales, variables locales
- `variables.tf` : Déclaration de toutes les variables d'entrée
- `outputs.tf` : Valeurs de sortie utiles pour le déploiement applicatif (Helm, etc.)
- `resourcegroup.tf` : Définition des Resource Groups et du stockage d'état
- `aks.tf` : Déploiement du cluster AKS et de la supervision
- `network.tf` : Réseau virtuel, subnets, NSG, DNS privé
- `postgresql.tf` : Déploiement du serveur PostgreSQL et configuration
- `key-vault.tf` : Déploiement du Key Vault et gestion des secrets
- `backend.tf` : Configuration du backend distant pour l'état Terraform (Azure Storage)
- `terraform.tfvars.example` : Exemple de fichier de variables à adapter
- `init-backend.sh` : Script pour initialiser le stockage d'état Azure
- `delete-backend.sh` : Script pour supprimer le stockage d'état Azure

---

## Utilisation

### 1. Initialiser le backend de stockage d'état

```bash
cd terraform
./init-backend.sh
```

### 2. Initialiser Terraform

```bash
terraform init
```

### 3. Adapter les variables

Copier `terraform.tfvars.example` en `terraform.tfvars` et adapter les valeurs selon votre environnement (utilisateur GitHub, région, etc.).

### 4. Planifier et appliquer le déploiement

```bash
terraform plan
terraform apply
```

### 5. Suppression du backend (optionnel)

Pour supprimer le stockage d'état Azure :

```bash
./delete-backend.sh
```

---

## Gestion des secrets

- Les mots de passe, tokens et autres secrets sont stockés dans **Azure Key Vault**.
- Les applications (backend, frontend) peuvent récupérer les secrets via Key Vault ou via les outputs Terraform.

---

## Pipeline CI/CD Terraform

- Un workflow GitHub Actions (`.github/workflows/terraform.yml`) permet de lancer les commandes `terraform plan` et `terraform apply` automatiquement.
- Les credentials Azure sont à fournir dans les secrets GitHub (`AZURE_CREDENTIALS`, etc.).
- L'état Terraform est stocké à distance dans Azure Storage pour garantir la cohérence et la collaboration.

---

## Déploiement multi-environnement

Pour déployer sur un environnement spécifique (ex: staging, prod), utilisez l'une des méthodes suivantes :

**Méthode 1 : Variable d'environnement**
```bash
terraform apply -var="environment=staging"
```

**Méthode 2 : Workspace Terraform**
```bash
terraform workspace new staging   # (à faire une seule fois)
terraform workspace select staging
terraform apply -var="environment=staging"
```
Les noms des ressources seront automatiquement adaptés (ex: `aks-devops-cicd-staging`).

---

## Livrables

- Code Terraform versionné dans le repo
- Environnement Azure opérationnel (AKS, DB, Key Vault, réseau, etc.)
- Secrets stockés de façon sécurisée dans Key Vault

---

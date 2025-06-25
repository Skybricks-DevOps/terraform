# Azure Key Vault pour stocker tous les secrets
resource "azurerm_key_vault" "main" {
  name                = local.key_vault_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"
  
  # Configuration de sécurité
  soft_delete_retention_days = 7
  purge_protection_enabled   = false # Désactivé pour faciliter les tests
  
  # Configuration d'accès réseau
  network_acls {
    default_action = "Allow" # En production, utilisez "Deny" et configurez les IPs autorisées
    bypass         = "AzureServices"
  }
  
  tags = local.common_tags
}

# Politique d'accès pour l'utilisateur/service principal actuel
resource "azurerm_key_vault_access_policy" "current_user" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  secret_permissions = [
    "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
  ]
  
  key_permissions = [
    "Get", "List", "Create", "Delete", "Update", "Recover", "Backup", "Restore", "Purge"
  ]
}

# Politique d'accès pour AKS (via son identité managée)
resource "azurerm_key_vault_access_policy" "aks" {
  key_vault_id = azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id

  secret_permissions = [
    "Get", "List"
  ]
}

# Secret: Mot de passe PostgreSQL
resource "azurerm_key_vault_secret" "postgresql_password" {
  name         = "postgresql-admin-password"
  value        = nonsensitive(local.postgresql_password)
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [azurerm_key_vault_access_policy.current_user]
  tags = local.common_tags
}

# Secret: Chaîne de connexion PostgreSQL complète
resource "azurerm_key_vault_secret" "postgresql_connection_string" {
  name         = "postgresql-connection-string"
  value        = nonsensitive("host=${azurerm_postgresql_flexible_server.main.fqdn} port=5432 dbname=${var.database_name} user=${var.db_admin_username} password=${local.postgresql_password} sslmode=require")
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [azurerm_key_vault_access_policy.current_user]
  tags = local.common_tags
}

# Secret: Token GitHub pour Container Registry
resource "azurerm_key_vault_secret" "github_token" {
  name         = "github-container-registry-token"
  value        = nonsensitive(var.github_token)
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [azurerm_key_vault_access_policy.current_user]
  tags = local.common_tags
}

# Secret: Nom d'utilisateur GitHub
resource "azurerm_key_vault_secret" "github_username" {
  name         = "github-username"
  value        = var.github_username
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [azurerm_key_vault_access_policy.current_user]
  tags = local.common_tags
}

# Secret: URL de l'API backend pour le frontend
resource "azurerm_key_vault_secret" "backend_api_url" {
  name         = "backend-api-url"
  value        = "http://backend-service:8000"
  key_vault_id = azurerm_key_vault.main.id
  
  depends_on = [azurerm_key_vault_access_policy.current_user]
  tags = local.common_tags
}

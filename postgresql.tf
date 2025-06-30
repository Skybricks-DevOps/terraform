# Génération d'un mot de passe sécurisé pour PostgreSQL (si non fourni)
resource "random_password" "postgresql_admin_password" {
  count   = var.pg_password == "" ? 1 : 0
  length  = 16
  special = true
  upper   = true
  lower   = true
  numeric = true
}

# Détermination du mot de passe à utiliser - avec gestion explicite de sensitive
locals {
  postgresql_password = nonsensitive(var.pg_password != "" ? var.pg_password : random_password.postgresql_admin_password[0].result)
}

# Serveur PostgreSQL Flexible
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = local.postgresql_server_name
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = var.postgresql_version
  
  # Configuration réseau - intégration avec VNet
  delegated_subnet_id    = azurerm_subnet.database.id
  private_dns_zone_id    = azurerm_private_dns_zone.postgresql.id
  
  # Configuration administrateur
  administrator_login    = var.db_admin_username
  administrator_password = local.postgresql_password
  
  # Configuration compute et stockage
  sku_name               = var.postgresql_sku_name
  storage_mb             = var.postgresql_storage_mb
  
  # Configuration de sauvegarde
  backup_retention_days  = 7
  geo_redundant_backup_enabled = false
  public_network_access_enabled = false
  tags = local.common_tags
  
  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgresql]
}

# Base de données pour l'application
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

# Configuration pour permettre l'accès depuis Azure services
# resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
#   name             = "AllowAzureServices"
#   server_id        = azurerm_postgresql_flexible_server.main.id
#   start_ip_address = "0.0.0.0"
#   end_ip_address   = "0.0.0.0"
# }

# Configuration de logs pour PostgreSQL
resource "azurerm_postgresql_flexible_server_configuration" "log_statement" {
  name      = "log_statement"
  server_id = azurerm_postgresql_flexible_server.main.id
  value     = "all"
}

# Attribution des rôles RBAC Azure pour l'accès au Key Vault
# Ces rôles sont nécessaires pour permettre à l'identité managée AKS d'accéder aux secrets du Key Vault via RBAC

resource "azurerm_role_assignment" "aks_key_vault_reader" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Reader"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

resource "azurerm_role_assignment" "aks_key_vault_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}

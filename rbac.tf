# Role assignment pour permettre à AKS d'accéder aux secrets dans Key Vault
resource "azurerm_role_assignment" "aks_keyvault_secrets" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
}
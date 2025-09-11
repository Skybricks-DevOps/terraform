provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.main.kube_config[0].host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
}

provider "helm" {
  kubernetes_host                   = azurerm_kubernetes_cluster.main.kube_config[0].host
  kubernetes_client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_certificate)
  kubernetes_client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].client_key)
  kubernetes_cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate)
}

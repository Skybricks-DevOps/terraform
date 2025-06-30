resource "azurerm_log_analytics_workspace" "main" {
  name                = local.log_analytics_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = local.common_tags
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = local.aks_cluster_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${local.project_name}-${local.environment}"
  
  # Version Kubernetes
  kubernetes_version = var.kubernetes_version
  
  # Configuration pour réduire les coûts
  sku_tier = "Free"

  default_node_pool {
    name                = "default"
    node_count          = var.aks_node_count
    vm_size             = var.aks_vm_size
    vnet_subnet_id      = azurerm_subnet.aks.id
    
    # Configuration de stockage optimisée
    os_disk_size_gb = 30
    os_disk_type    = "Managed"
    
    # Auto-scaling pour optimiser les coûts
    enable_auto_scaling = true
    min_count          = 1
    max_count          = 3
    
    # Configuration des nœuds
    max_pods = 30
    
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }
  
  # Configuration réseau
  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = "10.1.0.0/16"
    dns_service_ip    = "10.1.0.10"
  }

  # Add-ons
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }

  # Configuration RBAC et Azure AD
  role_based_access_control_enabled = true
  
  # Key Vault secrets provider
  key_vault_secrets_provider {
    secret_rotation_enabled = true
  }
  
  tags = local.common_tags
}

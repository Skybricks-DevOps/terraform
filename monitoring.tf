# Azure Monitor Workspace (Prometheus géré)
resource "azurerm_monitor_workspace" "main" {
  name                = "monitor-workspace-${var.environment}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Diagnostic settings pour AKS (logs/métriques vers Log Analytics)
resource "azurerm_monitor_diagnostic_setting" "aks" {
  name               = "aks-monitoring"
  target_resource_id = azurerm_kubernetes_cluster.main.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "kube-apiserver"
  }
  enabled_log {
    category = "kube-controller-manager"
  }
  enabled_log {
    category = "kube-scheduler"
  }
  enabled_log {
    category = "cluster-autoscaler"
  }
  enabled_log {
    category = "guard"
  }
  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Helm release Grafana sur AKS
resource "helm_release" "grafana" {
  depends_on = [azurerm_kubernetes_cluster.main]
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"
  create_namespace = true
  values = [
    # Tu peux ajouter ici la config adminPassword, service type, etc.
  ]
}

# Groupe d'action pour les alertes (email)
resource "azurerm_monitor_action_group" "main" {
  name                = "aks-alert-group"
  resource_group_name = azurerm_resource_group.main.name
  short_name          = "aksalerts"

  email_receiver {
    name          = "admin"
    email_address = var.alert_email # Ajoute cette variable dans variables.tf
  }
}

# Exemple d'alerte AKS sur la CPU
resource "azurerm_monitor_metric_alert" "aks_cpu" {
  name                = "aks-cpu-alert"
  resource_group_name = azurerm_resource_group.main.name
  scopes              = [azurerm_kubernetes_cluster.main.id]
  description         = "Alerte CPU AKS > 80%"
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT5M"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

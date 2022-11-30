resource "azurerm_resource_group" "prefix" {
  name     = "${var.prefix}-rg"
  location = "east us"

  tags = {
    environment = "Test"
  }
}
resource "azurerm_kubernetes_cluster" "prefix" {
  name                = "${var.prefix}-cluster"
  location            = azurerm_resource_group.prefix.location
  resource_group_name = azurerm_resource_group.prefix.name
  dns_prefix          = "${var.prefix}-cluster"
  node_resource_group = "${var.prefix}-noderg"

default_node_pool {
  enable_auto_scaling  = true
  max_count            = 1
  min_count            = 1
  name                 = "system"
  #orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb      = 1024
  vm_size              = "Standard_B2s"
  #availability_zones   = [1, 2, 3]
}

  service_principal {
    client_id     = var.appId
    client_secret = var.password
  }

  role_based_access_control_enabled = true

  tags = {
    environment = "Demo"
  }
}

# Create Linux Azure AKS Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "linux101" {
  #availability_zones    = [1, 2, 3]
  enable_auto_scaling   = true
  kubernetes_cluster_id = azurerm_kubernetes_cluster.prefix.id
  max_count             = 1
  min_count             = 1
  mode                  = "User"
  name                  = "linux101"
  #orchestrator_version  = data.azurerm_kubernetes_service_versions.current.latest_version
  os_disk_size_gb       = 30
  os_type               = "Linux" # Default is Linux, we can change to Windows
  vm_size               = "Standard_B2s"
  priority              = "Regular"  # Default is Regular, we can change to Spot with additional settings like eviction_policy, spot_max_price, node_labels and node_taints
}

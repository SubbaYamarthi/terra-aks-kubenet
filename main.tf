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

  default_node_pool {
    name            = "prefix"
    node_count      = 2
    vm_size         = "Standard_B2s"
    os_disk_size_gb = 30
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

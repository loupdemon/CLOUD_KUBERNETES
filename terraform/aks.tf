resource "azurerm_user_assigned_identity" "aks" {
  name                = "aks-uid"
  resource_group_name = data.azurerm_resource_group.rg-kubi.name
  location            = data.azurerm_resource_group.rg-kubi.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  resource_group_name = data.azurerm_resource_group.rg-kubi.name
  location            = data.azurerm_resource_group.rg-kubi.location
  dns_prefix          = "kubi-dns"
  

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v3"
    vnet_subnet_id  = azurerm_subnet.sub-aks.id
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    outbound_type  = "loadBalancer"
  }

  lifecycle {
    ignore_changes = [
      ingress_application_gateway
    ]
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "nodePool" {
  name                  = "workerpool1"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_D2_v3"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.sub-aks.id
}


resource "azurerm_role_assignment" "storage" {
  scope                = data.azurerm_storage_account.storage.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

resource "azurerm_role_assignment" "sbnet" {
  scope                = azurerm_subnet.sub-aks.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}



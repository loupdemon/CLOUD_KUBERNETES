# resource "azurerm_key_vault" "keyvault" {
#   name                        = "kv-kubi"
#   location                    = data.azurerm_resource_group.rg-kubi.location
#   resource_group_name         = data.azurerm_resource_group.rg-kubi.name
#   tenant_id                   = data.azurerm_client_config.current.tenant_id
#   sku_name                    = "standard"
# }

# resource "azurerm_key_vault_access_policy" "kv-access" {
#   key_vault_id = azurerm_key_vault.keyvault.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_user_assigned_identity.aks.principal_id

#   certificate_permissions = [
#     "Get"
#   ]

#   secret_permissions = [
#     "Get"
#   ]
# }

# resource "azurerm_key_vault_access_policy" "kv-acr-access" {
#   key_vault_id = azurerm_key_vault.keyvault.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id

#   certificate_permissions = [
#     "Get"
#   ]

#   secret_permissions = [
#     "Get"
#   ]
# }

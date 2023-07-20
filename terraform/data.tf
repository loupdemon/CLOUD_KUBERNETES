data "azurerm_resource_group" "rg-kubi" {
  name = "rg-kubi"
}

data "azurerm_client_config" "current" {
}

data "azurerm_storage_account" "storage" {
  name = "storagekubi"
  resource_group_name  = "rg-kubi"
}

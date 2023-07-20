terraform {
  backend "azurerm" {
    resource_group_name  = "rg-kubi"
    storage_account_name = "storagekubi"
    container_name       = "tfstate"
    key                  = "tfstate"
  }
}

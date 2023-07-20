resource "azurerm_virtual_network" "Vnet" {
  name                = "kubi-network"
  location            = data.azurerm_resource_group.rg-kubi.location
  resource_group_name = data.azurerm_resource_group.rg-kubi.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "sub-aks" {
  name                 = "subnet-aks"
  resource_group_name = data.azurerm_resource_group.rg-kubi.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "sub-appgw" {
  name                 = "subnet-appgw"
  resource_group_name = data.azurerm_resource_group.rg-kubi.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name = data.azurerm_resource_group.rg-kubi.name
  virtual_network_name = azurerm_virtual_network.Vnet.name
  address_prefixes     = ["10.1.3.0/24"]
}

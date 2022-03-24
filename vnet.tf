resource "azurerm_network_security_group" "oa_be_nsg" {
  name                = "oa-be-nsg"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
}

resource "azurerm_network_security_group" "oa_gw_nsg" {
  name                = "oa-gw-nsg"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
}

resource "azurerm_virtual_network" "oa_be_vnet" {
  name                = "oa-be-vnet"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  address_space       = ["10.148.0.0/16"]
}

resource "azurerm_virtual_network" "oa_gw_vnet" {
  name                = "oa-gw-vnet"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  address_space       = ["10.158.0.0/24"]
}

resource "azurerm_subnet" "oa_be_bast_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.oa_rsg.name
  virtual_network_name = azurerm_virtual_network.oa_be_vnet.name
  address_prefixes     = ["10.148.0.0/26"]
}

resource "azurerm_subnet" "oa_vm_subnet" {
  name                 = "oa-vm-subnet"
  resource_group_name  = azurerm_resource_group.oa_rsg.name
  virtual_network_name = azurerm_virtual_network.oa_be_vnet.name
  address_prefixes     = ["10.148.1.0/24"]
}

resource "azurerm_subnet" "oa_gw_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.oa_rsg.name
  virtual_network_name = azurerm_virtual_network.oa_gw_vnet.name
  address_prefixes     = ["10.158.0.0/27"]
}

resource "azurerm_virtual_network_peering" "oa_gw_2_be" {
  name                      = "oa-gw-2-be"
  resource_group_name       = azurerm_resource_group.oa_rsg.name
  virtual_network_name      = azurerm_virtual_network.oa_gw_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.oa_be_vnet.id
}

resource "azurerm_virtual_network_peering" "oa_be_2_gw" {
  name                      = "oa-be-2-gw"
  resource_group_name       = azurerm_resource_group.oa_rsg.name
  virtual_network_name      = azurerm_virtual_network.oa_be_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.oa_gw_vnet.id
}
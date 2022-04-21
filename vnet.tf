
resource "azurerm_virtual_network" "oa_be_vnet" {
  name                = "oa-be-vnet"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  address_space       = ["10.158.2.0/23"]  #Update
}

resource "azurerm_virtual_network" "oa_gw_vnet" {
  name                = "oa-gw-vnet"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  address_space       = ["10.158.0.0/24"] #Update
}

resource "azurerm_subnet" "oa_be_bast_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.oa_rsg.name
  virtual_network_name = azurerm_virtual_network.oa_be_vnet.name
  address_prefixes     = ["10.158.3.0/26"] #Update
}

resource "azurerm_subnet" "oa_vm_subnet" {
  name                 = "oa-vm-subnet"
  resource_group_name  = azurerm_resource_group.oa_rsg.name
  virtual_network_name = azurerm_virtual_network.oa_be_vnet.name
  address_prefixes     = ["10.158.2.0/24"] #Update
}

resource "azurerm_subnet" "oa_gw_subnet" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.oa_rsg.name
  virtual_network_name = azurerm_virtual_network.oa_gw_vnet.name
  address_prefixes     = ["10.158.0.0/27"] #Update
}

resource "azurerm_virtual_network_peering" "oa_gw_2_be" {
  name                      = "oa-gw-2-be"
  resource_group_name       = azurerm_resource_group.oa_rsg.name
  virtual_network_name      = azurerm_virtual_network.oa_gw_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.oa_be_vnet.id
  allow_forwarded_traffic   = true
  allow_gateway_transit     = true
}

resource "azurerm_virtual_network_peering" "oa_be_2_gw" {
  name                      = "oa-be-2-gw"
  resource_group_name       = azurerm_resource_group.oa_rsg.name
  virtual_network_name      = azurerm_virtual_network.oa_be_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.oa_gw_vnet.id
}
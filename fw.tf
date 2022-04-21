resource "azurerm_subnet" "oa_be_fw_subnet" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.oa_rsg.name
  virtual_network_name = azurerm_virtual_network.oa_gw_vnet.name
  address_prefixes     = ["10.158.0.64/26"] #Update
}

resource "azurerm_public_ip" "oa_be_fw_ip" {
  name                = "oa-fw-ip"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_firewall" "oa_be_fw" {
  name                = "oa-be-fw"
  sku_tier            = "Premium"
  sku_name            = "AZFW_VNet"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.oa_be_fw_subnet.id
    public_ip_address_id = azurerm_public_ip.oa_be_fw_ip.id
  }
}
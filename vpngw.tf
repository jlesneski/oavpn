resource "azurerm_public_ip" "oa_gw_ip" {
  name                = "oa-gw-ip"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  allocation_method = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "oa_gw_vpn" {
  name                = "oa-gw-vpn"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Basic"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.oa_gw_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.oa_gw_subnet.id
  }
}
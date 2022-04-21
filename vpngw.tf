resource "azurerm_public_ip" "oa_gw_ip" {
  name                = "oa-gw-ip"
  sku                 = "Standard"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "oa_gw_vpn" {
  name                = "oa-gw-vpn"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = true
  sku           = "VpnGw2AZ"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.oa_gw_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.oa_gw_subnet.id
  }
  bgp_settings {
    asn                           = 65501
  }
}

resource "azurerm_local_network_gateway" "masergy" {
  name                = "masergy-vpn-device"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name
  gateway_address     = "64.47.160.46"
  address_space       = ["100.64.0.100/30"]
  bgp_settings {
    asn                 = "19855" 
    bgp_peering_address = "100.64.0.103"  
  }
}

resource "azurerm_virtual_network_gateway_connection" "oa_s2s_masergy" {
  name                = "MasergyS2S"
  location            = azurerm_resource_group.oa_rsg.location
  resource_group_name = azurerm_resource_group.oa_rsg.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.oa_gw_vpn.id
  local_network_gateway_id   = azurerm_local_network_gateway.masergy.id

  shared_key = data.azurerm_key_vault_secret.oa_vpn_shared_key.value
  connection_protocol = "IKEv2"
  enable_bgp          = "true"
  ipsec_policy {
    dh_group          = "DHGroup2"
    ike_encryption    = "AES256"
    ike_integrity     = "SHA384"
    ipsec_encryption  = "AES256"  
    ipsec_integrity   = "SHA256"
    pfs_group         = "PFS2"
    sa_lifetime       = "27000"
  }
}
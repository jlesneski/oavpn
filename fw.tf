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

resource "azurerm_storage_account" "oa_fw_storage" {
  name                     = "oafwstorage"
  resource_group_name      = azurerm_resource_group.oa_rsg.name
  location                 = azurerm_resource_group.oa_rsg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
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

resource "azurerm_monitor_diagnostic_setting" "oa_fw_diags" {
  name               = "diaglogging"
  target_resource_id = azurerm_firewall.oa_be_fw.id
  storage_account_id = azurerm_storage_account.oa_fw_storage.id

  log {
    category = "AzureFirewallApplicationRule"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureFirewallNetworkRule"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzureFirewallDnsProxy"
    enabled  = true
    retention_policy {
      enabled = false
    }
  }

  metric {
    category = "AllMetrics"
    retention_policy {
      enabled = false
    }
  }
}
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "oa_key_vault" {
  name                        = "oa-vpn-key-vault"
  location                    = azurerm_resource_group.oa_rsg.location
  resource_group_name         = azurerm_resource_group.oa_rsg.name
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "Set",
      "List",
      "Delete"
    ]
  }
}

data "azurerm_key_vault_secret" "oa_vpn_shared_key" {
  name         = "vpn-shared-key"
  key_vault_id = azurerm_key_vault.oa_key_vault.id
}

data "azurerm_key_vault_secret" "oa_vm_admin_user" {
  name         = "vm-admin-user"
  key_vault_id = azurerm_key_vault.oa_key_vault.id
}

data "azurerm_key_vault_secret" "oa_vm_admin_pass" {
  name         = "vm-admin-pass"
  key_vault_id = azurerm_key_vault.oa_key_vault.id
}
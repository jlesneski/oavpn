resource "azurerm_public_ip" "oa_bastion_ip" {
    name                = "oa-bastion-ip"
    location            = azurerm_resource_group.oa_rsg.location
    resource_group_name = azurerm_resource_group.oa_rsg.name
    allocation_method   = "Static"
    sku                 = "Standard"
}

resource "azurerm_bastion_host" "oa_bastion" {
    name                = "oa-bastion"
    location            = azurerm_resource_group.oa_rsg.location
    resource_group_name = azurerm_resource_group.oa_rsg.name
    ip_configuration {
        name                 = "configuration"
        subnet_id            = azurerm_subnet.oa_be_bast_subnet.id
        public_ip_address_id = azurerm_public_ip.oa_bastion_ip.id
    }
}

resource "azurerm_network_interface" "oa_nic_vm1" {
    name                = "oa-vm-nic1"
    location            = azurerm_resource_group.oa_rsg.location
    resource_group_name = azurerm_resource_group.oa_rsg.name

    ip_configuration {
        name                          = "oa-vm-conf-nic1"
        subnet_id                     = azurerm_subnet.oa_vm_subnet.id
        private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_virtual_machine" "oa_test_vm" {
    name                  = "oa-test-vm"
    location              = azurerm_resource_group.oa_rsg.location
    resource_group_name   = azurerm_resource_group.oa_rsg.name
    network_interface_ids = [azurerm_network_interface.oa_nic_vm1.id]
    vm_size               = "Standard_D2as_v5"
    delete_os_disk_on_termination = true
    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }
    storage_os_disk {
        name              = "oa-test-vm-os"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }
    os_profile {
        computer_name  = "oa-test-vm"
        admin_username = data.azurerm_key_vault_secret.oa_vm_admin_user.value
        admin_password = data.azurerm_key_vault_secret.oa_vm_admin_pass.value
    }
    os_profile_linux_config {
        disable_password_authentication = false
    }
}
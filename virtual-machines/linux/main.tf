###======================================================================================
### Copyright (c) 2024, Bobby Wen, All Rights Reserved 
### Use of this source code is governed by a MIT-style
### license that can be found at https://en.wikipedia.org/wiki/MIT_License.
### Project:		Microsoft Azurerm Kubernetes examples 
### Class:			Terraform Azurerm IaC file
### Purpose:    Terraform script to create Microsoft Azure Linux server with a public IP
### Usage:			terraform (init|plan|apply|destroy)
### Pre-requisites:	Azure subscription (https://azure.microsoft.com/en-us/), 
###                 Terraform by HashiCorp (https://www.terraform.io/)
### Beware:     Variables.tf file is used to pass environment variable to main.tf.  
###             Depending on SDLC environmental setting, different attributes are passed to create the stack 
###
### Developer: 	Bobby Wen, bobby@wen.org
###======================================================================================
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name = "${var.prefix}-resources"
  location = var.location[var.environment]
  tags     = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pip" {
  name                = "${var.prefix}-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Dynamic"
  tags                = local.tags
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic1"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags

  ip_configuration {
    name                          = "primary"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip.id
  }
}

resource "azurerm_network_interface" "internal" {
  name                = "${var.prefix}-nic2"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "ssh" {
  name                = "vm-ssh"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags = merge(local.tags, {
    security = "SSH inbound from allowed IPs"
  security_rule {
    access                     = "Allow"
    direction                  = "Inbound"
    name                       = "ssh"
    priority                   = 100
    protocol                   = "Tcp"
    source_port_range          = "*"
    source_address_prefixes    = var.ingress_cidr_blocks[var.environment]
    destination_port_range     = "22"
    destination_address_prefix = azurerm_network_interface.main.private_ip_address
  }
}

resource "azurerm_network_interface_security_group_association" "main" {
  network_interface_id      = azurerm_network_interface.internal.id
  network_security_group_id = azurerm_network_security_group.ssh.id
}

resource "azurerm_linux_virtual_machine" "main" {
  name                = "${var.prefix}-vm"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
  size           = var.az_instance_type[var.environment]
  admin_username = "adminuser"
  admin_password = "MyP@ssw0rd2024!"
  network_interface_ids = [
    azurerm_network_interface.main.id,
  ]

  admin_ssh_key {
    username = "adminuser"
    public_key = file("../../../../id_rsa.pub")
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

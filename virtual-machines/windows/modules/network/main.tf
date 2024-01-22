###======================================================================================
### Copyright (c) 2024, Bobby Wen, All Rights Reserved 
### Use of this source code is governed by a MIT-style
### license that can be found at https://en.wikipedia.org/wiki/MIT_License.
### Project:		Microsoft Azurerm examples 
### Class:			Terraform Azurerm IaC file
### Purpose:    Terraform script to create Microsoft Azure Windows server with Active directory controller
### Usage:			terraform (init|plan|apply|destroy)
### Pre-requisites:	Azure subscription (https://azure.microsoft.com/en-us/), 
###                 Terraform by HashiCorp (https://www.terraform.io/)
### Beware:     Variables.tf file is used to pass environment variable to main.tf.  
###             Depending on SDLC environmental setting, different attributes are passed to create the stack 
###
### Developer: 	Bobby Wen, bobby@wen.org
###======================================================================================

resource "azurerm_virtual_network" "example" {
  name                = join("-", [var.prefix, "network"])
  location            = var.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = var.resource_group_name
  dns_servers         = ["10.0.1.4", "8.8.8.8"]
}

resource "azurerm_subnet" "domain-controllers" {
  name                 = "domain-controllers"
  address_prefixes     = ["10.0.1.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
}

resource "azurerm_subnet" "domain-members" {
  name                 = "domain-members"
  address_prefixes     = ["10.0.2.0/24"]
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
}
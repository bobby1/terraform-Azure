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
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "=3.0.0"
      version = "=3.88.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  location = var.location[var.environment]
  name     = "${var.prefix}-rg"
  tags     = local.tags
}

module "network" {
  source              = "./modules/network"
  environment         = var.environment
  location            = var.location[var.environment]
  resource_group_name = azurerm_resource_group.example.name
  prefix              = var.prefix
}

module "active-directory-domain" {
  source                        = "./modules/active-directory-domain"
  environment                   = var.environment
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  active_directory_domain_name  = "${var.prefix}.local"
  active_directory_netbios_name = var.prefix
  admin_username                = var.admin_username
  # admin_password                = var.admin_password
  admin_password = file("../../../../admin_password.txt")
  prefix         = var.prefix
  subnet_id      = module.network.domain_controllers_subnet_id
  ### NOTE: AD requires a larger VM size,  It is hard coded to Standard_F2  in modules/active-directory-domain/main.tf
}

module "active-directory-member" {
  source                       = "./modules/domain-member"
  environment                  = var.environment
  location                     = azurerm_resource_group.example.location
  resource_group_name          = azurerm_resource_group.example.name
  size                         = var.az_instance_type[var.environment]
  prefix                       = var.prefix
  active_directory_domain_name = "${var.prefix}.local"
  active_directory_username    = var.admin_username
  # active_directory_password    = var.admin_password
  active_directory_password = file("../../../../admin_password.txt")
  admin_username            = var.admin_username
  # admin_password               = var.admin_password
  admin_password = file("../../../../admin_password.txt")
  subnet_id      = module.network.domain_members_subnet_id
}

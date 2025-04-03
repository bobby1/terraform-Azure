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
output "public_ip_address" {
  value = azurerm_public_ip.static.ip_address
}

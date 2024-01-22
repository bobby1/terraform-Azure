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
variable "project_name" {
  description = "product or project name"
  type        = string
  default     = "DevOps tools team"
}

variable "prefix" {
  description = "A prefix used for all resources in this example"
  type        = string
  default     = "b1AZwnd"
}

variable "environment" {
  description = "SDLC Infrastructure environment: THIS SETS THE DEPLOYMENT ENVIRONMENT"
  type        = string
  default     = "dev"
}

variable "instance_name" {
  description = "Value of the Name tag for the instance"
  type        = string
  default     = "DevOps_team"
}

variable "location" {
  description = "The Azure Region in which all resources in this environment should be provisioned"
  type        = map(string)
  default = {
    dev = "westus"
    stg = "westus2"
    prd = "westus3"
  }
}

variable "az_instance_type" {
  description = "Azure instance type"
  type        = map(string)
  default = {
    dev = "Standard_B1s"
    stg = "Standard_F2"
    prd = "Standard_DS2_v2"
  }
}

variable "admin_username" {
  description = "Username for the Administrator account"
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "Password for the Administrator account"
  type        = string
  default     = "AZPassword230118!"
}

locals {
  tags = {
    project     = var.project_name
    environment = var.environment
    name        = var.instance_name
  }
}

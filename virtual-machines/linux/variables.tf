###======================================================================================
### Copyright (c) 2024, Bobby Wen, All Rights Reserved 
### Use of this source code is governed by a MIT-style
### license that can be found at https://en.wikipedia.org/wiki/MIT_License.
### Project:		Microsoft Azurerm examples
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
variable "project_name" {
  description = "product or project name"
  type        = string
  default     = "DevOps tools team"
}

variable "environment" {
  description = "SDLC Infrastructure environment: THIS SETS THE DEPLOYMENT ENVIRONMENT"
  type        = string
  default     = "dev"
}

variable "prefix" {
  description = "A prefix used for all resources in this example"
  type        = string
  default     = "b1AZtst"
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

variable "instance_name" {
  description = "Value of the Name tag for the instance"
  type        = string
  default     = "DevOps tools team test"
}

variable "az_instance_type" {
  description = "EC2 instance type"
  type        = map(string)
  default = {
    dev = "Standard_B1s"     
    ### 1 vCPU, 1 GiB RAM (freetier)
    stg = "Standard_Bats_v2" 
    ### 2 vCPU, 1 GiB RAM (freetier)
    prd = "Standard_DS2_v2"
  }
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks to allow in the security group"
  type        = map(list(string))
  default = {
    ### 67.174.209.57/32 is an access IP address DEBUG
    dev = ["67.174.209.57/32", ]
    ### 54.86.126.30/24 is a company's IP address range  ### DEBUG
    stg = ["54.86.126.30/24", ]
    prd = ["0.0.0.0/0", ]
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

###======================================================================================
### Copyright (c) 2024, Bobby Wen, All Rights Reserved 
### Use of this source code is governed by a MIT-style
### license that can be found at https://en.wikipedia.org/wiki/MIT_License.
### Project:		Microsoft Azurerm Kubernetes examples 
### Class:			Terraform Azurerm IaC file
### Purpose:    Terraform script to create Microsoft Azure Kubernetes Cluster with Monitoring and public IP
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
  default     = "b1AZtst"
}

variable "environment" {
  description = "SDLC Infrastructure environment: THIS SETS THE DEPLOYMENT ENVIRONMENT"
  type        = string
  default     = "dev"
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
  description = "EC2 instance type"
  type        = map(string)
  default = {
    ### K8 cluster must use VM sku with more than 2 cores and 4GB memory
    dev = "Standard_B2als_v2" ### B2als_v2 is smallest 2 cores and 4GB memory VM but is not free
    stg = "Standard_B2als_v2"
    prd = "Standard_DS2_v2"
  }
}

variable "az_key_name" {
  description = "preconfigured key name"
  type        = string
  default     = "az_key"
}

variable "instance_count" {
  description = "Number of instances to provision."
  type        = map(number)
  default = {
    dev = 1
    stg = 2
    prd = 5
  }
}

variable "ingress_cidr_blocks" {
  description = "CIDR blocks to allow in the security group"
  type        = map(list(string))
  default = {
    ### 67.174.209.57/32 is an access IP address DEBUG
    dev = ["67.174.209.57/32", ]
    stg = ["54.86.126.30/24", "67.174.209.57/32", ]
    prd = ["0.0.0.0/0", ]
  }
}

variable "instance_name" {
  description = "Value of the Name tag for the instance"
  type        = string
  default     = "DevOps tools team"
}

locals {
  tags = {
    project     = var.project_name
    environment = var.environment
    name        = var.instance_name
  }
}

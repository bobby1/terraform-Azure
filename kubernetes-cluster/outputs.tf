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
output "id" {
  value = azurerm_kubernetes_cluster.main.id
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.main.kube_config.0.client_key
  sensitive = true
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.main.kube_config.0.client_certificate
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate
  sensitive = true
}

output "host" {
  value     = azurerm_kubernetes_cluster.main.kube_config.0.host
  sensitive = true
}

output "cluster_egress_ip" {
  value = data.azurerm_public_ip.main.ip_address
}
//======================================================================================
// Copyright (c) 2024, Bobby Wen, All Rights Reserved 
// Use of this source code is governed by a MIT-style
// license that can be found at https://en.wikipedia.org/wiki/MIT_License.
// Project:		Microsoft Azurerm Kubernetes examples 
// Class:			Terraform Azurerm IaC file
// Purpose:    Terraform script to create Microsoft Azure Kubernetes Cluster with Monitoring and public IP
// Usage:			terraform (init|plan|apply|destroy)
// Pre-requisites:	Azure subscription (https://azure.microsoft.com/en-us/), 
//                 Terraform by HashiCorp (https://www.terraform.io/)
// Beware:     Variables.tf file is used to pass environment variable to main.tf.  
//             Depending on SDLC environmental setting, different attributes are passed to create the stack 
//
// Developer: 	Bobby Wen, bobby@wen.org
//======================================================================================
provider "azurerm" {
  features {}
  # NOTE: default_tags not available for azurerm provider
}

#  Setting up a Kubernetes Cluster with Monitoring Enabled
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location[var.environment]
  tags     = local.tags
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["192.168.0.0/16"]
  tags                = local.tags
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  address_prefixes     = ["192.168.1.0/24"]
  virtual_network_name = azurerm_virtual_network.main.name
  service_endpoints    = ["Microsoft.Sql"]
}

# Monitoring
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.prefix}-law"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  tags                = local.tags
}

resource "azurerm_log_analytics_solution" "main" {
  solution_name         = "Containers"
  location              = azurerm_resource_group.main.location
  workspace_name        = azurerm_log_analytics_workspace.main.name
  workspace_resource_id = azurerm_log_analytics_workspace.main.id
  resource_group_name   = azurerm_resource_group.main.name
  tags                  = local.tags

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = "${var.prefix}-k8s"
  tags = merge(local.tags, {
    workload = "K8 cluster"
  })

  default_node_pool {
    # name = "default"
    name       = "${var.environment}default"
    node_count = var.instance_count[var.environment]
    vm_size    = var.az_instance_type[var.environment]
    tags       = local.tags
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.main.id
    msi_auth_for_monitoring_enabled = true
  }
}

data "azurerm_public_ip" "main" {
  name                = reverse(split("/", tolist(azurerm_kubernetes_cluster.main.network_profile.0.load_balancer_profile.0.effective_outbound_ips)[0]))[0]
  resource_group_name = azurerm_kubernetes_cluster.main.node_resource_group
}

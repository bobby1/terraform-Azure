# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
  default     = "b1AZtest"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
  default     = "westus"
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


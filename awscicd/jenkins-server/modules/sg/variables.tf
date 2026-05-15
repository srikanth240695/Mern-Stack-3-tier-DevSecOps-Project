variable "server_name" {
  description = "The name of the server"
  type        = string
}

variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}
variable "server_name" {
  description = "The name of the server"
  type        = string
}

variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "availability_zone" {
  description = "The availability zone for the subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}
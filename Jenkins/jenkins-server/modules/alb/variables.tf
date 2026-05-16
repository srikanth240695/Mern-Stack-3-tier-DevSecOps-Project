variable "server_name" {
  description = "The name of the server"
  type        = string
}

variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}

variable "alb_security_group_ids" {
  description = "The IDs of the security groups to assign to the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "instance_id" {
  description = "The ID of the EC2 instance to target"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN"
  type        = string
}


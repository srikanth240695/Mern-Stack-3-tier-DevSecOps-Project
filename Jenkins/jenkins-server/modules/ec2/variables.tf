variable "server_name" {
  description = "The name of the server"
  type        = string
}

variable "environment" {
  description = "The environment for the VPC (e.g., dev, staging, prod)"
  type        = string
}

variable "key_pair_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
}

variable "ami_id" {
  description = "The ID of the AMI to use for the EC2 instance"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "The ID of the IAM instance profile to assign to the EC2 instance"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group to assign to the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the EC2 instance will be launched"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the subnets where the EC2 instance will be launched"
  type        = string
}

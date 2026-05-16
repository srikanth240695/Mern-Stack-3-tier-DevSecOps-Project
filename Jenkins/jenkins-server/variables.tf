variable "aws_region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "environment" {
  description = "The environment for the server"
  type        = string
}

variable "server_name" {
  description = "The name of the server"
  type        = string

}

variable "instance_type" {
  description = "The type of the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "key_pair_name" {
  description = "The name of the key pair to use for the EC2 instance"
  type        = string
}

variable "availability_zone" {
  type        = list(string)
  description = "The list of availability zones from jenkins.tfvars"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "The list of CIDR blocks for public subnets from jenkins.tfvars"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "The list of CIDR blocks for private subnets from jenkins.tfvars"
}

# variable "domain_name" {
#   description = "The domain name for the Route 53 record"
#   type        = string
# }
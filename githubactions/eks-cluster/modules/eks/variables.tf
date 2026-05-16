variable "environment" {
  description = "The environment for the EKS cluster (e.g., dev, staging, prod)"
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "EKS Kubernetes version"
  type        = string
}

variable "endpoint_private_access" {
  description = "Whether the EKS cluster endpoint is accessible privately"
  type        = bool
}

variable "endpoint_public_access" {
  description = "Whether the EKS cluster endpoint is accessible publicly"
  type        = bool
}

variable "addons" {
  type = list(object({
    name = string
  }))
}

variable "desired_size_ondemand" {
  description = "The desired number of ON_DEMAND nodes in the node group"
  type        = number
}

variable "maximum_size_ondemand" {
  description = "The maximum number of ON_DEMAND nodes in the node group"
  type        = number
}

variable "minimum_size_ondemand" {
  description = "The minimum number of ON_DEMAND nodes in the node group"
  type        = number
}

variable "ondemand_instance_types" {
  description = "The instance types for the ON_DEMAND node group"
  type        = list(string)
}

variable "spot_instance_types" {
  description = "The instance types for the SPOT node group"
  type        = list(string)
}

variable "desired_size_spot" {
  description = "The desired number of SPOT nodes in the node group"
  type        = number
}

variable "maximum_size_spot" {
  description = "The maximum number of SPOT nodes in the node group"
  type        = number
}

variable "minimum_size_spot" {
  description = "The minimum number of SPOT nodes in the node group"
  type        = number
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_cluster_security_group_id" {
  description = "Security group ID for EKS cluster"
  type        = string
}
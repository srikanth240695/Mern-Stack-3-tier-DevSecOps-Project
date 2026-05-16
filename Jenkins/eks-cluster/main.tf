module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zone    = var.availability_zone
  cluster_name         = var.cluster_name
  environment          = var.environment

}

module "eks" {
  source = "./modules/eks"

  cluster_name                  = var.cluster_name
  kubernetes_version            = var.kubernetes_version
  environment                   = var.environment
  public_subnet_ids             = module.vpc.public_subnet_ids
  private_subnet_ids            = module.vpc.private_subnet_ids
  endpoint_private_access       = var.endpoint_private_access
  endpoint_public_access        = var.endpoint_public_access
  desired_size_ondemand         = var.desired_size_ondemand
  maximum_size_ondemand         = var.maximum_size_ondemand
  minimum_size_ondemand         = var.minimum_size_ondemand
  ondemand_instance_types       = var.ondemand_instance_types
  desired_size_spot             = var.desired_size_spot
  maximum_size_spot             = var.maximum_size_spot
  minimum_size_spot             = var.minimum_size_spot
  spot_instance_types           = var.spot_instance_types
  addons                        = var.addons
  eks_cluster_security_group_id = module.vpc.eks_cluster_security_group_id
} 
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr_block       = var.vpc_cidr_block
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zone    = var.availability_zone
  server_name          = var.server_name
  environment          = var.environment
}

module "ec2" {
  source = "./modules/ec2"

  server_name               = var.server_name
  environment               = var.environment
  vpc_id                    = module.vpc.vpc_id
  public_subnet_ids         = module.vpc.public_subnet_ids[0]
  security_group_id         = module.sg.jenkins_security_group_id
  iam_instance_profile_name = module.iam.instance_profile_name
  ami_id                    = var.ami_id
  instance_type             = var.instance_type
  key_pair_name             = var.key_pair_name
}

module "alb" {
  source = "./modules/alb"

  server_name            = var.server_name
  environment            = var.environment
  vpc_id                 = module.vpc.vpc_id            # Fixed: Passed required VPC context
  public_subnet_ids      = module.vpc.public_subnet_ids # Fixed: Passed ID references instead of raw CIDRs
  instance_id            = module.ec2.instance_id       # Fixed: Passed target instance destination
  alb_security_group_ids = [module.sg.alb_security_group_id]
  acm_certificate_arn    = "arn:aws:acm:us-west-2:046374119637:certificate/19f4bf12-7921-497a-9c6c-20fc7f465345"
}

module "sg" {
  source = "./modules/sg"

  server_name = var.server_name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "iam" {
  source = "./modules/iam"

  server_name = var.server_name
  environment = var.environment
}

# module "route53_dns" {
#   source = "./modules/route53_dns"

#   domain_name = var.domain_name
#   alb_dns_name = module.alb.dns_name
#   alb_zone_id = module.alb.zone_id
#   environment = var.environment
# }
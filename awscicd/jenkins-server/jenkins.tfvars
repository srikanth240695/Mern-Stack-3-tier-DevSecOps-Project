
# For Jenkins CICD
server_name          = "jenkins-server"
environment          = "dev"
vpc_cidr_block       = "12.0.0.0/16"
public_subnet_cidrs  = ["12.0.1.0/24", "12.0.2.0/24"]
private_subnet_cidrs = ["12.0.11.0/24", "12.0.12.0/24"]
availability_zone    = ["us-west-2a", "us-west-2b"]
aws_region           = "us-west-2"
ami_id               = "ami-05cf1e9f73fbad2e2"
instance_type        = "t2.2xlarge"
key_pair_name        = "devops_demo_key_pair"
# domain_name = "advithkrishiv.xyz"

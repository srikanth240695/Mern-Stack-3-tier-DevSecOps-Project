region                  = "us-west-2"
environment             = "nonprod"
cluster_name            = "mern-eks-cluster"
vpc_cidr_block          = "10.0.0.0/16"
availability_zone       = ["us-west-2a", "us-west-2b", "us-west-2c"]
public_subnet_cidrs     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_cidrs    = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
kubernetes_version      = "1.33"
minimum_size_ondemand   = 1
desired_size_ondemand   = 2
maximum_size_ondemand   = 5
endpoint_private_access = true
endpoint_public_access  = true
ondemand_instance_types = ["t3a.medium"]
spot_instance_types     = ["c5a.large", "c5a.xlarge", "m5a.large", "m5a.xlarge", "c5.large", "m5.large", "t3a.large", "t3a.xlarge", "t3a.medium"]
minimum_size_spot       = 1
desired_size_spot       = 2
maximum_size_spot       = 5
addons = [
  {
    name = "vpc-cni",
  },
  {
    name = "coredns"
  },
  {
    name = "kube-proxy"
  },
  {
    name = "aws-ebs-csi-driver"
  }
  # Add more addons as needed
]

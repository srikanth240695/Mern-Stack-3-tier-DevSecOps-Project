terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "srikanth-mern-stack-backend-2026"
    key            = "eks-cluster/dev/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "mern-lock-table"
    encrypt        = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# VPC Module
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "MyVPC"
  cidr = "10.10.0.0/16"  # CIDR block for the VPC

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]  # Private subnets
  public_subnets  = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]  # Public subnets

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# EKS Module
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  
  control_plane_subnet_ids = module.vpc.public_subnets  # Using public subnets for control plane

  subnet_ids               = module.vpc.private_subnets  # Private subnets for worker nodes

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    example = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

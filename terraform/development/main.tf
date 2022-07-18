provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key

}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_id]
      command     = "aws"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "clederson-tfstate"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

####################### VPC ########################

# Two tier VPC is being created: 
# public subnets with IGW
# private subnet with NAT

module "network" {
  source = "./../modules/network"

  vpc_cidr                = var.vpc_cidr
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  environment             = var.environment
  product                 = var.product
  single_natgw            = var.single_natgw
  dual_az_only            = var.dual_az_only
  account_id              = var.account_id
  region                  = var.region
  enable_dns_hostnames    = var.enable_dns_hostnames
  enable_dns_support      = var.enable_dns_support
  map_public_ip_on_launch = var.map_public_ip_on_launch
  domain_name             = var.domain_name
}

####################### EKS ########################

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.23.0"

  cluster_name    = "${var.environment}-${var.product}-eks"
  cluster_version = "1.22"
  subnet_ids      = module.network.private_subnets

  vpc_id = module.network.vpc_id


  # Extend cluster security group rules
  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  # Extend node-to-node security group rules
  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    eks-nodes = {
      min_size     = 2
      max_size     = 10
      desired_size = 2

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT" #"ON_DEMAND"
    }
  }
}

module "k8s_addons" {
  source      = "./../modules/k8s-addons"
  dns_zone_id = module.network.aws_route53_zone_id
}
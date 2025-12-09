terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.30.0"
    }
  }
  backend "s3" {}
}

provider "aws" {
  region = var.region
}

module "network" {
  source = "../../modules/network"
  name   = "${var.name}-stg"
  vpc_cidr = var.vpc_cidr
  public_subnets = {
    a = { cidr = var.public_subnet_cidr_a, az = "${var.region}a" },
    b = { cidr = var.public_subnet_cidr_b, az = "${var.region}b" }
  }
  private_subnets = {
    a = { cidr = var.private_subnet_cidr_a, az = "${var.region}a" },
    b = { cidr = var.private_subnet_cidr_b, az = "${var.region}b" }
  }
}

module "eks" {
  source             = "../../modules/eks"
  name               = "${var.name}-stg"
  region             = var.region
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_ids
  workload_min       = 2
  workload_desired   = 2
  workload_max       = 4
}

module "iam" {
  source = "../../modules/iam"
  name   = "${var.name}-stg"
}

output "cluster_name" {
  value = module.eks.cluster_name
}

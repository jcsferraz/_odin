provider "aws" {
  region  = var.aws_region
  profile = "cloud-engineers"
}

terraform {
  backend "s3" {
    bucket = "consulteanuvem-tf-states"
    key    = "global/services/consulteanuvem-main.tfstate"
    region = "us-east-1"
    encrypt        = true
    dynamodb_table = "global-state-files-consulteanuvem"
  }
}

module "network_vpc_dev" {
  source  = "./account/vops-cloud/network/envs/dev/vpc/src"
  vpc_cidr_block           = var.vpc_cidr_block
  cidr_blocks              = var.cidr_blocks
  secondary_vpc_cidr_block = var.secondary_vpc_cidr_block
  public_subnets = [
    { cidr_blocks = "11.0.2.0/23", zone = "us-east-1a", name = "subnet-dev-a-pub" },
    { cidr_blocks = "11.0.4.0/23", zone = "us-east-1b", name = "subnet-dev-b-pub" },
    { cidr_blocks = "11.0.6.0/23", zone = "us-east-1c", name = "subnet-dev-c-pub" }
  ]

  private_subnets = [
    { cidr_blocks = "11.0.8.0/23", zone = "us-east-1a", name = "subnet-dev-a-priv" },
    { cidr_blocks = "11.0.10.0/23", zone = "us-east-1b", name = "subnet-dev-b-priv" },
    { cidr_blocks = "11.0.12.0/23", zone = "us-east-1c", name = "subnet-dev-c-priv" }
  ]
}

module "dynamodb_global_tables_dev" {
  source  = "./account/vops-cloud/data-stores/envs/dev/dynamodb/src"
}


module "openshift-community_masters_dev" {
  source  = "./account/vops-cloud/services/openshift-community/envs/dev/masters/src"
  vpc  = var.vpc
  vpc_cidr_block = var.vpc_cidr_block
  cidr_blocks    = var.cidr_blocks
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}


module "openshift-community_nodes_dev" {
  source  = "./account/vops-cloud/services/openshift-community/envs/dev/nodes/src"
  vpc  = var.vpc
  vpc_cidr_block = var.vpc_cidr_block
  cidr_blocks    = var.cidr_blocks
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

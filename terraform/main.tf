# Main Terraform configuration file
# This file orchestrates all modules

# Network Module
module "network_vpc_dev" {
  source                   = "./account/vops-cloud/network/envs/dev/vpc/src"
  vpc_cidr_block           = var.vpc_cidr_block
  cidr_blocks              = var.cidr_blocks
  secondary_vpc_cidr_block = var.secondary_vpc_cidr_block
  public_subnets           = var.public_subnets
  private_subnets          = var.private_subnets
}

# Data Stores Module
module "dynamodb_global_tables_dev" {
  source = "./account/vops-cloud/data-stores/envs/dev/dynamodb/src"
}

# EKS Module
module "eks_cluster_dev" {
  source = "./account/vops-cloud/services/eks/envs/dev/main/src"
  
  cluster_name    = "isengard-${var.environment}"
  cluster_version = var.eks_cluster_version
  
  vpc_id             = module.network_vpc_dev.vpc_id
  private_subnet_ids = module.network_vpc_dev.private_subnet_ids
  public_subnet_ids  = module.network_vpc_dev.public_subnet_ids
  
  node_groups = var.eks_node_groups
  ssh_key_name = var.ssh_key_name
  
  # Admin role for cluster access
  admin_role_arn = "arn:aws:iam::590184028041:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_OpsTamAdms_dfe8619e7180816c"
  
  tags = {
    Environment = var.environment
    Project     = "isengard"
    ManagedBy   = "terraform"
    auto-delete = "no"
  }
}

# OpenShift Modules (commented out)
#module "openshift-community_masters_dev" {
#  source  = "./account/vops-cloud/services/openshift-community/envs/dev/masters/src"
#  vpc  = var.vpc
#  vpc_cidr_block = var.vpc_cidr_block
#  cidr_blocks    = var.cidr_blocks
#  private_subnets = var.private_subnets
#  public_subnets  = var.public_subnets
# }

#module "openshift-community_nodes_dev" {
#  source  = "./account/vops-cloud/services/openshift-community/envs/dev/nodes/src"
#  vpc  = var.vpc
#  vpc_cidr_block = var.vpc_cidr_block
#  cidr_blocks    = var.cidr_blocks
#  private_subnets = var.private_subnets
#  public_subnets  = var.public_subnets
# }
provider "aws" {
  region = var.aws_region
  
  default_tags {
    tags = {
      Environment = var.environment
      Project     = "isengard"
      ManagedBy   = "terraform"
      auto-delete = "no"
    }
  }
}

# Modules are defined in their respective module files
# See: account/vops-cloud/network/module_vpc.tf
# See: account/vops-cloud/data-stores/module_dynamodb.tf


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

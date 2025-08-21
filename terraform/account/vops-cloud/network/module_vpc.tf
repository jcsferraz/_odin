# This file is kept for reference but the actual module call
# is now centralized in terraform/main.tf to avoid duplication

# module "network_vpc_dev" {
#   source                   = "./envs/dev/vpc/src/"
#   vpc_cidr_block           = var.vpc_cidr_block
#   secondary_vpc_cidr_block = var.secondary_vpc_cidr_block
#   cidr_blocks              = var.cidr_blocks
#   public_subnets           = var.public_subnets
#   private_subnets          = var.private_subnets
# }
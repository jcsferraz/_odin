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
    #dynamodb_table = "global-state-consulteanuvem-lock-dynamo"
  }
}

module "network_vpc_dev" {
  source  = "./account/vops-cloud/network/envs/dev/vpc/src"
}

module "dynamodb_global_tables_dev" {
  source  = "./account/vops-cloud/data-stores/envs/dev/dynamodb/src"
}


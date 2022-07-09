provider "aws" {
  region  = var.aws_region
  profile = "cloud-engineers"
}

terraform {
  backend "s3" {
    bucket = "consulteanuvem-tf-states"
    key    = "global/services/consulteanuvem-tf-states.tf"
    region = "us-east-1"
  }
}
